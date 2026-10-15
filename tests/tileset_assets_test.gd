extends SceneTree

const TileGenerator = preload("res://tools/generate_tilesets.gd")

var checks: int = 0
var failures: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		printerr("FAIL: ", message)


func _read(path: String) -> Image:
	var image := Image.new()
	_check(image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK, "PNG dapat dibaca: " + path)
	return image


func _run() -> void:
	_test_sources()
	for group in ["terrain", "buildings", "environment"]:
		_check(FileAccess.file_exists("res://assets/tilesets/" + group + "_16.png"), "Atlas tersedia: " + group)
	if failures > 0:
		_finish()
		return
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/tilesets/manifest.json"))
	_check(manifest.tile_size == [16.0, 16.0] and manifest.margin == [1.0, 1.0] and manifest.separation == [2.0, 2.0], "Konfigurasi grid dan padding benar")
	var allowed := ["3b302a", "78604a", "c4aa84", "4b5445", "c76b36", "8b4036", "e9dcc7"]
	var terrain: Dictionary = {}
	for group in ["terrain", "buildings", "environment"]:
		var data: Dictionary = manifest.atlases[group]
		var image := _read("res://" + data.path)
		var expected: Vector2i = {"terrain": Vector2i(144, 90), "buildings": Vector2i(144, 72), "environment": Vector2i(144, 108)}[group]
		_check(image.get_size() == expected, "Dimensi atlas: " + group)
		var valid := true
		for y in range(image.get_height()):
			for x in range(image.get_width()):
				var pixel := image.get_pixel(x, y)
				valid = valid and (pixel.a == 0.0 or (pixel.a == 1.0 and pixel.to_html(false) in allowed))
		_check(valid, "Palet dan alpha atlas: " + group)
		var texture := load("res://" + data.path) as Texture2D
		_check(texture != null and texture.get_size() == Vector2(expected), "Resource Texture2D valid: " + group)
		var atlas_source := TileSetAtlasSource.new()
		atlas_source.texture = texture
		atlas_source.texture_region_size = Vector2i(16, 16)
		atlas_source.margins = Vector2i.ONE
		atlas_source.separation = Vector2i(2, 2)
		var occupied: Dictionary = {}
		for asset in data.assets:
			_check(int(asset.size_px[0]) % 16 == 0 and int(asset.size_px[1]) % 16 == 0 and asset.cells.size() == int(asset.size_px[0]) * int(asset.size_px[1]) / 256, "Ukuran objek dan jumlah sel: " + asset.id)
			var assembled := Image.create(int(asset.size_px[0]), int(asset.size_px[1]), false, Image.FORMAT_RGBA8)
			assembled.fill(Color.TRANSPARENT)
			for cell in asset.cells:
				var pos := Vector2i(int(cell.atlas[0]), int(cell.atlas[1]))
				var region := Rect2i(pos * 18 + Vector2i.ONE, Vector2i(16, 16))
				_check(not occupied.has(pos) and Rect2i(Vector2i.ZERO, image.get_size()).encloses(region), "Koordinat unik dan di dalam atlas: " + asset.id)
				occupied[pos] = true
				atlas_source.create_tile(pos)
				_check(atlas_source.has_tile(pos) and atlas_source.get_tile_texture_region(pos) == region, "TileSetAtlasSource membaca sel dengan benar: " + asset.id)
				_check(cell.pixel_region == [float(region.position.x), float(region.position.y), 16.0, 16.0], "Metadata pixel region benar: " + asset.id)
				var tile := image.get_region(region)
				var offset := Vector2i(cell.offset_px[0], cell.offset_px[1])
				_check(offset.x % 16 == 0 and offset.y % 16 == 0 and Rect2i(Vector2i.ZERO, assembled.get_size()).encloses(Rect2i(offset, Vector2i(16, 16))), "Offset objek kelipatan 16 dan berada dalam batas: " + asset.id)
				assembled.blit_rect(tile, Rect2i(0, 0, 16, 16), offset)
				var extrusion_ok := true
				for y in range(-1, 17):
					for x in range(-1, 17):
						extrusion_ok = extrusion_ok and image.get_pixel(region.position.x + x, region.position.y + y) == tile.get_pixel(clampi(x, 0, 15), clampi(y, 0, 15))
				_check(extrusion_ok, "Padding mengekstrusi tepi tile: " + asset.id)
				if group == "terrain":
					terrain[asset.id] = tile
			_check(assembled.get_used_rect().has_area(), "Aset yang dirakit tidak kosong: " + asset.id)
			_check(asset.opaque == (assembled.detect_alpha() == Image.ALPHA_NONE), "Metadata opacity sesuai PNG: " + asset.id)
		_check(occupied.size() == {"terrain": 40, "buildings": 32, "environment": 48}[group], "Jumlah sel atlas sesuai rancangan: " + group)
	for pair in [["soil", "soil_pebbles"], ["road_dirt", "road_dust"], ["cobble", "cobble_worn"]]:
		for side in range(4):
			_check(_edge_equal(terrain[pair[0]], terrain[pair[1]], side), "Varian permukaan tersambung: " + str(pair) + "/" + str(side))
	for a in range(16):
		for b in range(16):
			if bool(a & 2) == bool(b & 8):
				_check(_edge_equal(terrain["road_mask_" + str(a)], terrain["road_mask_" + str(b)], 1), "Sambungan road mask horizontal: " + str(a) + "/" + str(b))
			if bool(a & 4) == bool(b & 1):
				_check(_edge_equal(terrain["road_mask_" + str(a)], terrain["road_mask_" + str(b)], 2), "Sambungan road mask vertikal: " + str(a) + "/" + str(b))
	for pair in [["road_corner_nw", "road_edge_n", 1], ["road_edge_n", "road_corner_ne", 1], ["road_corner_nw", "road_edge_w", 2], ["road_edge_w", "road_corner_sw", 2], ["road_inner_nw", "road_edge_n", 3], ["road_inner_nw", "road_edge_w", 0]]:
		_check(_edge_equal(terrain[pair[0]], terrain[pair[1]], pair[2]), "Sambungan tepi dan sudut: " + pair[0] + "/" + pair[1])
	var preview := _read("res://docs/art/tilesets/map_preview.png")
	_check(preview.get_size() == Vector2i(512, 320), "Preview map sesuai grid 32x20")
	_check(preview.detect_alpha() == Image.ALPHA_NONE, "Preview map tidak memiliki celah transparan")
	var contact := _read("res://docs/art/tilesets/contact_sheet.png")
	_check(contact.get_size() == Vector2i(832, 1536), "Contact sheet mencakup tiga atlas")
	var enlarged := _read("res://docs/art/tilesets/map_preview_3x.png")
	_check(enlarged.get_size() == Vector2i(1536, 960), "Preview diperbesar integer 3x")
	var nearest := true
	for y in range(enlarged.get_height()):
		for x in range(enlarged.get_width()):
			nearest = nearest and enlarged.get_pixel(x, y) == preview.get_pixel(x / 3, y / 3)
	_check(nearest, "Preview map nearest-neighbor per piksel")
	_finish()


func _test_sources() -> void:
	var source: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/tilesets.json"))
	var layout: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/tileset_preview.json"))
	var palette: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/art_sources/palette.json"))
	var colors := {".": Color.TRANSPARENT}
	for item in palette.colors:
		colors[item.symbol] = Color(item.hex)
	_check(TileGenerator.validate_tiles(source, layout, colors).is_empty(), "Sumber valid diterima")
	var bad := source.duplicate(true)
	bad.padding = 2
	_check(not TileGenerator.validate_tiles(bad, layout, colors).is_empty(), "Padding sumber yang salah ditolak")
	bad = source.duplicate(true)
	bad.environment[0].cell = [2, 0]
	_check(not TileGenerator.validate_tiles(bad, layout, colors).is_empty(), "Penempatan atlas tumpang tindih ditolak")
	bad = source.duplicate(true)
	bad.environment[0].ops[0].rect[0] = 31
	_check(not TileGenerator.validate_tiles(bad, layout, colors).is_empty(), "Operasi gambar keluar objek ditolak")
	bad = source.duplicate(true)
	bad.blueprints[0].rows[0][0] = "module_missing"
	_check(not TileGenerator.validate_tiles(bad, layout, colors).is_empty(), "Referensi modul bangunan hilang ditolak")
	bad = source.duplicate(true)
	bad.environment[0].cell[0] = 0.5
	_check(not TileGenerator.validate_tiles(bad, layout, colors).is_empty(), "Koordinat subpiksel ditolak")
	bad = source.duplicate(true)
	bad.mask_bits.north = 2
	_check(not TileGenerator.validate_tiles(bad, layout, colors).is_empty(), "Metadata bitmask tidak boleh menyimpang dari gambar")
	var bad_layout := layout.duplicate(true)
	bad_layout.environment[0].at = [31, 19]
	_check(not TileGenerator.validate_tiles(source, bad_layout, colors).is_empty(), "Objek preview keluar map ditolak")


func _edge_equal(a: Image, b: Image, direction: int) -> bool:
	for i in range(16):
		if direction == 0 and a.get_pixel(i, 0) != b.get_pixel(i, 15):
			return false
		if direction == 1 and a.get_pixel(15, i) != b.get_pixel(0, i):
			return false
		if direction == 2 and a.get_pixel(i, 15) != b.get_pixel(i, 0):
			return false
		if direction == 3 and a.get_pixel(0, i) != b.get_pixel(15, i):
			return false
	return true


func _finish() -> void:
	print("TILESET_ASSET_RESULT checks=", checks, " failures=", failures)
	quit(1 if failures > 0 else 0)
