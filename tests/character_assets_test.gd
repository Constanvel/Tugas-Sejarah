extends SceneTree

const CharacterGenerator = preload("res://tools/generate_characters.gd")

var checks: int = 0
var failures: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, message: String) -> void:
	checks += 1
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		printerr("FAIL: ", message)


func _read_png(path: String) -> Image:
	var image := Image.new()
	var error := image.load_png_from_buffer(FileAccess.get_file_as_bytes(path))
	_check(error == OK, "PNG dapat dibaca: " + path.get_file())
	return image


func _run() -> void:
	_test_source_validation()
	for id in ["player", "enemy", "civilian"]:
		_check(FileAccess.file_exists("res://assets/sprites/characters/" + id + ".png"), "Aset tersedia: " + id)
	if failures > 0:
		_finish()
		return
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/sprites/characters/manifest.json"))
	_check(manifest.row_order == ["down", "left", "right", "up"] and manifest.column_order == ["idle", "walk_a", "walk_b"], "Urutan atlas sesuai permintaan")
	_check(manifest.frame_size == [16.0, 24.0] and manifest.pivot == [8.0, 23.0], "Frame dan pivot kaki dicatat")
	var colors := ["3b302a", "78604a", "c4aa84", "4b5445", "c76b36", "8b4036", "e9dcc7"]
	var sheets: Dictionary = {}
	for id in ["player", "enemy", "civilian"]:
		var image := _read_png("res://assets/sprites/characters/" + id + ".png")
		var animated: bool = id != "civilian"
		var size := Vector2i(48, 96) if animated else Vector2i(16, 24)
		_check(image.get_size() == size, "Dimensi tepat: " + id)
		if image.get_size() != size:
			continue
		sheets[id] = image
		var valid := true
		for y in range(size.y):
			for x in range(size.x):
				var pixel := image.get_pixel(x, y)
				valid = valid and (pixel.a == 0.0 or (pixel.a == 1.0 and pixel.to_html(false) in colors))
		_check(valid, "Palet tujuh warna dan alpha 0/255: " + id)
		var texture := load("res://assets/sprites/characters/" + id + ".png") as Texture2D
		_check(texture != null and texture.get_size() == Vector2(size), "Texture2D Godot valid: " + id)
		var idle_views: Array = []
		for row in range(4 if animated else 1):
			var frames: Array[Image] = []
			for col in range(3 if animated else 1):
				var frame := image.get_region(Rect2i(col * 16, row * 24, 16, 24))
				frames.append(frame)
				var bounds := frame.get_used_rect()
				_check(bounds.has_area() and Rect2i(1, 1, 14, 22).encloses(bounds), "Siluet utuh dengan margin transparan: " + id + " " + str(row) + "/" + str(col))
				_check(bounds.end.y == 23, "Kaki tepat pada baris 22: " + id + " " + str(row) + "/" + str(col))
			if animated:
				_check(_different_pixels(frames[0], frames[1], 10) >= 12 and _different_pixels(frames[0], frames[2], 10) >= 12 and _different_pixels(frames[1], frames[2], 10) >= 12, "Ketiga pose berbeda jelas pada tubuh/kaki: " + id + " arah " + str(row))
				_check(_different_pixels(frames[1], frames[2], 17) >= 8, "Walk A/B mengubah kaki, bukan hanya warna kepala: " + id + " arah " + str(row))
				_check(frames[0].get_region(Rect2i(0, 0, 16, 9)).get_data() == frames[1].get_region(Rect2i(0, 0, 16, 9)).get_data() and frames[0].get_region(Rect2i(0, 0, 16, 9)).get_data() == frames[2].get_region(Rect2i(0, 0, 16, 9)).get_data(), "Kepala tidak bergeser antar langkah: " + id + " arah " + str(row))
				_check(frames[0].get_data() not in idle_views, "Arah memiliki gambar berbeda: " + id + " arah " + str(row))
				idle_views.append(frames[0].get_data())
		var preview := _read_png("res://docs/art/characters/" + id + "_8x.png")
		_check(preview.get_size() == size * 8, "Preview delapan kali ukuran asli: " + id)
		var nearest := true
		if preview.get_size() == size * 8:
			for y in range(preview.get_height()):
				for x in range(preview.get_width()):
					nearest = nearest and preview.get_pixel(x, y) == image.get_pixel(x / 8, y / 8)
		_check(nearest, "Preview tepat nearest-neighbor tanpa blur: " + id)
	if sheets.size() == 3:
		_check(sheets.player.get_region(Rect2i(0, 0, 16, 24)).get_data() != sheets.enemy.get_region(Rect2i(0, 0, 16, 24)).get_data() and sheets.civilian.get_data() != sheets.player.get_region(Rect2i(0, 0, 16, 24)).get_data(), "Identitas visual ketiga karakter berbeda")
	_finish()


func _test_source_validation() -> void:
	var source: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/characters.json"))
	var palette: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/palette.json"))
	var colors := {".": Color.TRANSPARENT}
	for entry in palette.colors:
		colors[entry.symbol] = Color(entry.hex)
	_check(CharacterGenerator.validate_characters(source, colors).is_empty(), "Sumber karakter valid diterima")
	var bad := source.duplicate(true)
	bad.characters[0].id = "../enemy"
	_check(not CharacterGenerator.validate_characters(bad, colors).is_empty(), "ID yang dapat menimpa path lain ditolak")
	bad = source.duplicate(true)
	bad.characters[0].views.down.walk_a = {}
	_check(not CharacterGenerator.validate_characters(bad, colors).is_empty(), "Pose langkah kosong ditolak")
	bad = source.duplicate(true)
	bad.characters[0].views.down.walk_a["24"] = "................"
	_check(not CharacterGenerator.validate_characters(bad, colors).is_empty(), "Perubahan piksel di luar frame ditolak")
	bad = source.duplicate(true)
	bad.characters[0].views.down.walk_a["3"] = "................"
	_check(not CharacterGenerator.validate_characters(bad, colors).is_empty(), "Langkah tidak boleh menggeser kepala")
	bad = source.duplicate(true)
	bad.characters[0].views.down.idle[22] = "................"
	_check(not CharacterGenerator.validate_characters(bad, colors).is_empty(), "Kaki di luar baseline ditolak")
	bad = source.duplicate(true)
	bad.characters[0].erase("function")
	_check(not CharacterGenerator.validate_characters(bad, colors).is_empty(), "Metadata fungsi yang hilang ditolak sebelum menulis PNG")


func _different_pixels(a: Image, b: Image, from_y: int) -> int:
	var count := 0
	for y in range(from_y, 24):
		for x in range(16):
			if a.get_pixel(x, y) != b.get_pixel(x, y):
				count += 1
	return count


func _finish() -> void:
	print("CHARACTER_ASSET_RESULT checks=", checks, " failures=", failures)
	quit(1 if failures > 0 else 0)
