extends SceneTree

const Generator = preload("res://tools/generate_assets.gd")

var failures: int = 0
var checks: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, message: String) -> void:
	checks += 1
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		printerr("FAIL: ", message)


func _run() -> void:
	_test_sources()
	var path := "res://assets/generated/manifest.json"
	_check(FileAccess.file_exists(path), "Manifest keluaran pipeline tersedia")
	if failures > 0:
		_finish()
		return
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(path))
	_check(manifest is Dictionary and manifest.get("assets", []).size() == 5, "Manifest mencatat tepat tiga studi, palet dan preview")
	if failures > 0:
		_finish()
		return
	var allowed := ["3b302a", "78604a", "c4aa84", "4b5445", "c76b36", "8b4036", "e9dcc7"]
	var images: Dictionary = {}
	for entry in manifest.assets:
		var image := Image.new()
		var error := image.load_png_from_buffer(FileAccess.get_file_as_bytes("res://" + entry.path))
		_check(error == OK, "PNG dapat dibaca: " + entry.id)
		if error != OK:
			continue
		images[entry.id] = image
		_check(image.get_size() == Vector2i(entry.size[0], entry.size[1]), "Dimensi sesuai manifest: " + entry.id)
		var valid_pixels := true
		var has_clear := false
		var has_solid := false
		for y in range(image.get_height()):
			for x in range(image.get_width()):
				var color := image.get_pixel(x, y)
				valid_pixels = valid_pixels and (color.a == 0.0 or (color.a == 1.0 and color.to_html(false) in allowed))
				has_clear = has_clear or color.a == 0.0
				has_solid = has_solid or color.a == 1.0
		_check(valid_pixels and has_solid, "Hanya tujuh warna dan alpha biner: " + entry.id)
		_check(has_clear == entry.transparent, "Transparansi sesuai fungsi: " + entry.id)
		if entry.category in ["characters", "props", "tiles"]:
			var texture := load("res://" + entry.path) as Texture2D
			_check(texture != null and texture.get_size() == Vector2(entry.size[0], entry.size[1]), "Resource PNG dapat dimuat Godot: " + entry.id)
	if failures > 0:
		_finish()
		return
	var player: Image = images.courier_idle_south
	_check(player.get_size() == Vector2i(16, 24), "Frame karakter tepat 16x24")
	_check(player.get_pixel(0, 0).a == 0.0 and player.get_pixel(7, 4).to_html(false) == "8b4036", "Siluet transparan dan aksen kepala terjaga")
	var tile: Image = images.dirt_tile
	var seamless := true
	for i in range(16):
		seamless = seamless and tile.get_pixel(0, i) == tile.get_pixel(15, i) and tile.get_pixel(i, 0) == tile.get_pixel(i, 15)
	_check(seamless, "Tepi tile cocok saat diulang")
	var palette: Image = images.palette
	_check(palette.get_size() == Vector2i(7, 1), "Strip palet memiliki tujuh swatch")
	for i in range(7):
		_check(palette.get_pixel(i, 0).to_html(false) == allowed[i], "Nilai warna PRD tepat: " + allowed[i])
	var reference: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/art/reference_manifest.json"))
	var concept := Image.new()
	_check(concept.load_png_from_buffer(FileAccess.get_file_as_bytes("res://" + reference.path)) == OK, "PNG referensi AI dapat dibaca")
	_check(concept.get_size() == Vector2i(1536, 1024) and reference.size == [1536.0, 1024.0], "Dimensi referensi AI tepat dan dicatat terpisah")
	_check(not reference.production_ready and not reference.integrated and not reference.palette_exact, "Referensi AI tidak dinyatakan sebagai aset produksi")
	_finish()


func _test_sources() -> void:
	var palette: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/palette.json"))
	var source: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/foundation_samples.json"))
	var colors := {".": Color.TRANSPARENT}
	for entry in palette.colors:
		colors[entry.symbol] = Color(entry.hex)
	_check(Generator.validate_palette(palette).is_empty(), "Sumber palet valid diterima")
	_check(Generator.validate_sample(source.samples[0], colors).is_empty(), "Sumber frame karakter valid diterima")
	var bad := palette.duplicate(true)
	bad.colors.pop_back()
	_check(not Generator.validate_palette(bad).is_empty(), "Palet kurang dari tujuh warna ditolak")
	bad = palette.duplicate(true)
	bad.colors[1].symbol = "D"
	_check(not Generator.validate_palette(bad).is_empty(), "Simbol warna duplikat ditolak")
	bad = palette.duplicate(true)
	bad.colors[0].hex = "#GGGGGG"
	_check(not Generator.validate_palette(bad).is_empty(), "Kode hex tidak valid ditolak")
	bad = palette.duplicate(true)
	bad.colors[4].symbol = "X"
	_check(not Generator.validate_palette(bad).is_empty(), "Simbol palet yang dibutuhkan guide tidak boleh hilang")
	bad = source.samples[0].duplicate(true)
	bad.id = "../keluar_folder"
	_check(not Generator.validate_sample(bad, colors).is_empty(), "ID tidak dapat keluar dari folder generated")
	bad = source.samples[0].duplicate(true)
	bad.size = [32, 24]
	bad.frame_size = [32, 24]
	_check(not Generator.validate_sample(bad, colors).is_empty(), "Ukuran karakter selain 16x24 ditolak")
	bad = source.samples[0].duplicate(true)
	bad.rows[0] = "?..............."
	_check(not Generator.validate_sample(bad, colors).is_empty(), "Simbol piksel di luar palet ditolak")
	bad = source.samples[1].duplicate(true)
	bad.rects[0][0] = 31
	_check(not Generator.validate_sample(bad, colors).is_empty(), "Bidang di luar frame ditolak")
	bad = source.samples[1].duplicate(true)
	bad.rects[0][0] = 1.5
	_check(not Generator.validate_sample(bad, colors).is_empty(), "Koordinat subpiksel ditolak")
	bad = source.samples[0].duplicate(true)
	bad.pivot = [8, 25]
	_check(not Generator.validate_sample(bad, colors).is_empty(), "Pivot di luar frame ditolak")
	bad = source.samples[0].duplicate(true)
	bad.rects = []
	_check(not Generator.validate_sample(bad, colors).is_empty(), "Sumber rows dan rects ganda ditolak")


func _finish() -> void:
	print("ASSET_PIPELINE_RESULT checks=", checks, " failures=", failures)
	quit(1 if failures > 0 else 0)
