extends "res://tools/generate_assets.gd"

const Foundation = preload("res://tools/generate_assets.gd")
const TILE_SOURCE := "res://assets/art_sources/tilesets.json"
const MAP_SOURCE := "res://assets/art_sources/tileset_preview.json"
const TILE_OUTPUT := "res://assets/tilesets/"
const TILE_DOCS := "res://docs/art/tilesets/"
const TERRAIN_VARIANTS := {
	"surface": ["soil", "soil_pebbles", "road_dirt", "road_dust", "cobble", "cobble_worn", "grass", "dry_soil"],
	"road_edge": ["n", "e", "s", "w"], "road_corner": ["nw", "ne", "se", "sw"],
	"road_inner": ["nw", "ne", "se", "sw"], "decoration": ["pebbles", "grass_tuft", "fallen_leaves", "dust_patch"]
}
const BUILD_VARIANTS := {
	"roof": ["center", "left", "right", "top_left", "top", "top_right", "worn"],
	"eave": ["left", "center", "right"], "wall": ["plaster", "aged", "left", "right", "brick", "timber", "patch"],
	"door": ["wood_top", "wood_bottom", "colonial_top", "colonial_bottom"],
	"window": ["wood", "colonial", "vent", "shutter", "booth"], "step": ["plain"],
	"pillar": ["plain"], "foundation": ["plaster", "aged"], "post": ["left", "right"]
}


static func _ints(value: Variant, length: int, low: int, high: int) -> bool:
	if not value is Array or value.size() != length:
		return false
	for number in value:
		if not (number is int or number is float) or number != int(number) or number < low or number > high:
			return false
	return true


static func validate_tiles(source: Variant, layout: Variant, colors: Dictionary) -> String:
	if not source is Dictionary or source.get("tile_size") != [16.0, 16.0] or source.get("padding") != 1 or source.get("columns") != 8:
		return "Gunakan tile 16x16, padding 1 dan delapan kolom."
	if not source.get("mask_bits") is Dictionary or source.mask_bits.size() != 4:
		return "Empat arah bitmask wajib dicatat."
	for pair in [["north", 1], ["east", 2], ["south", 4], ["west", 8]]:
		if source.mask_bits.get(pair[0]) != pair[1]:
			return "Bitmask harus north=1, east=2, south=4, west=8."
	var ids: Dictionary = {}
	for group in ["terrain", "buildings", "environment"]:
		if not source.get(group) is Array or source[group].size() != {"terrain": 40, "buildings": 32, "environment": 25}[group]:
			return "Jumlah aset tidak sesuai rancangan: " + group
		ids[group] = {}
		for asset in source[group]:
			if not asset is Dictionary or not asset.get("id") is String or not asset.id.is_valid_identifier() or ids[group].has(asset.id):
				return "ID aset tidak valid atau duplikat."
			ids[group][asset.id] = asset
			if group == "terrain":
				if asset.get("kind") == "road_mask":
					if not (asset.get("mask") is int or asset.get("mask") is float) or asset.mask != int(asset.mask) or asset.mask < 0 or asset.mask > 15 or asset.id != "road_mask_" + str(int(asset.mask)):
						return "Road mask harus memiliki nilai 0..15 dan ID yang sesuai."
				else:
					if not TERRAIN_VARIANTS.has(asset.get("kind")) or asset.get("variant") not in TERRAIN_VARIANTS[asset.kind]:
						return "Resep terrain tidak dikenal."
					var prefix: String = {"surface": "", "road_edge": "road_edge_", "road_corner": "road_corner_", "road_inner": "road_inner_", "decoration": "deco_"}[asset.kind]
					if asset.id != prefix + asset.variant:
						return "ID terrain tidak sesuai resep."
			elif group == "buildings":
				if not BUILD_VARIANTS.has(asset.get("kind")) or asset.get("variant") not in BUILD_VARIANTS[asset.kind]:
					return "Resep bangunan tidak dikenal."
	var occupied: Dictionary = {}
	for asset in source.environment:
		if not _ints(asset.get("size"), 2, 16, 128) or int(asset.size[0]) % 16 != 0 or int(asset.size[1]) % 16 != 0 or not _ints(asset.get("cell"), 2, 0, 7):
			return "Ukuran atau koordinat objek tidak sesuai grid."
		for y in range(int(asset.size[1]) / 16):
			for x in range(int(asset.size[0]) / 16):
				var cell := Vector2i(int(asset.cell[0]) + x, int(asset.cell[1]) + y)
				if cell.x >= 8 or cell.y >= 6 or occupied.has(cell):
					return "Objek tumpang tindih atau berada di luar atlas."
				occupied[cell] = true
		if not asset.get("ops") is Array or asset.ops.is_empty():
			return "Objek tidak memiliki operasi gambar."
		for op in asset.ops:
			if not op is Dictionary or not colors.has(op.get("color")):
				return "Warna objek tidak ada di palet."
			if op.get("type") == "rect":
				if not _ints(op.get("rect"), 4, 0, 128) or op.rect[2] < 1 or op.rect[3] < 1 or op.rect[0] + op.rect[2] > asset.size[0] or op.rect[1] + op.rect[3] > asset.size[1]:
					return "Bidang objek keluar dari frame."
			elif op.get("type") == "polygon":
				if not op.get("points") is Array or op.points.size() < 3:
					return "Poligon objek tidak valid."
				for point in op.points:
					if not _ints(point, 2, 0, 128) or point[0] > asset.size[0] or point[1] > asset.size[1]:
						return "Titik poligon di luar frame."
			else:
				return "Operasi gambar tidak dikenal."
	if occupied.size() != 48:
		return "Atlas objek harus mengisi 48 sel."
	if not source.get("blueprints") is Array or source.blueprints.size() != 4:
		return "Diperlukan empat contoh bangunan modular."
	ids["blueprints"] = {}
	for building in source.blueprints:
		if not building is Dictionary or not building.get("id") is String or not building.id.is_valid_identifier() or ids.blueprints.has(building.id) or not building.get("rows") is Array or building.rows.is_empty():
			return "Blueprint bangunan tidak valid."
		var width: int = 0
		for row in building.rows:
			if not row is Array or row.is_empty() or (width > 0 and row.size() != width):
				return "Baris blueprint harus berbentuk persegi panjang."
			width = row.size()
			for id in row:
				if not ids.buildings.has(id):
					return "Blueprint mengacu pada modul yang tidak tersedia."
		ids.blueprints[building.id] = building
	if not layout is Dictionary or layout.get("size_tiles") != [32.0, 20.0]:
		return "Preview map harus berukuran 32x20 tile."
	for group in ["buildings", "environment"]:
		if not layout.get(group) is Array:
			return "Daftar penempatan preview tidak valid."
		for item in layout[group]:
			var lookup: Dictionary = ids.blueprints if group == "buildings" else ids.environment
			if not item is Dictionary or not lookup.has(item.get("id")) or not _ints(item.get("at"), 2, 0, 31):
				return "ID atau koordinat preview tidak valid."
			var asset: Dictionary = lookup[item.id]
			var size := Vector2i(asset.rows[0].size(), asset.rows.size()) if group == "buildings" else Vector2i(int(asset.size[0]) / 16, int(asset.size[1]) / 16)
			if int(item.at[0]) + size.x > 32 or int(item.at[1]) + size.y > 20:
				return "Penempatan preview keluar map."
	return ""


func _surface(variant: String, colors: Dictionary) -> Image:
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(colors.O if variant == "grass" else colors.W)
	if variant.begins_with("cobble"):
		for y in [2, 6, 10]:
			var shift: int = 3 if y == 6 else 0
			for x in range(2 + shift, 14, 6):
				image.fill_rect(Rect2i(x, y, mini(4, 15 - x), 3), colors.D)
				image.fill_rect(Rect2i(x, y, mini(3, 15 - x), 2), colors.B if variant == "cobble" else colors.W)
	elif variant == "dry_soil":
		for point in [Vector2i(4, 5), Vector2i(5, 6), Vector2i(6, 7), Vector2i(7, 8), Vector2i(8, 8), Vector2i(7, 9), Vector2i(6, 10), Vector2i(10, 4)]:
			image.set_pixelv(point, colors.D)
	else:
		var seed_shift: int = 3 if variant in ["soil_pebbles", "road_dust"] else (5 if variant == "road_dirt" else 0)
		for i in range(5 if variant == "road_dust" else 3):
			var x := 2 + (i * 5 + seed_shift) % 12
			var y := 2 + (i * 7 + seed_shift) % 12
			image.fill_rect(Rect2i(x, y, 2, 1), colors.W if variant == "grass" else colors.B)
		if variant == "soil_pebbles":
			image.fill_rect(Rect2i(6, 10, 3, 2), colors.D)
		elif variant == "road_dirt":
			image.fill_rect(Rect2i(3, 6, 4, 1), colors.B)
		elif variant == "road_dust":
			image.fill_rect(Rect2i(5, 8, 6, 1), colors.B)
	return image


func _terrain(asset: Dictionary, colors: Dictionary) -> Image:
	if asset.kind == "surface":
		return _surface(asset.variant, colors)
	var image := _surface("grass", colors)
	if asset.kind == "decoration":
		image.fill(Color.TRANSPARENT)
		if asset.variant == "grass_tuft":
			for rect in [Rect2i(4, 7, 2, 7), Rect2i(7, 4, 2, 10), Rect2i(10, 8, 2, 6)]:
				image.fill_rect(rect, colors.O)
		elif asset.variant == "pebbles":
			image.fill_rect(Rect2i(3, 9, 4, 3), colors.D)
			image.fill_rect(Rect2i(3, 9, 3, 1), colors.B)
			image.fill_rect(Rect2i(10, 5, 2, 2), colors.W)
		elif asset.variant == "fallen_leaves":
			image.fill_rect(Rect2i(3, 4, 3, 1), colors.R)
			image.fill_rect(Rect2i(8, 10, 4, 1), colors.O)
			image.set_pixel(11, 6, colors.B)
		else:
			image.fill_rect(Rect2i(4, 7, 6, 1), colors.B)
			image.fill_rect(Rect2i(7, 11, 5, 1), colors.W)
		return image
	var road := _surface("road_dirt", colors)
	for y in range(16):
		for x in range(16):
			var inside := false
			if asset.kind == "road_mask":
				var mask: int = int(asset.mask)
				inside = (x >= 3 and x <= 12 and y >= 3 and y <= 12) or (bool(mask & 1) and x >= 3 and x <= 12 and y < 8) or (bool(mask & 2) and y >= 3 and y <= 12 and x >= 8) or (bool(mask & 4) and x >= 3 and x <= 12 and y >= 8) or (bool(mask & 8) and y >= 3 and y <= 12 and x < 8)
				if (x == 3 or x == 12) and (y == 3 or y == 12):
					inside = false
			elif asset.kind == "road_edge":
				inside = {"n": y >= 4, "e": x < 12, "s": y < 12, "w": x >= 4}[asset.variant]
			elif asset.kind == "road_corner":
				inside = (x >= 4 if asset.variant.ends_with("w") else x < 12) and (y >= 4 if asset.variant.begins_with("n") else y < 12)
			else:
				inside = not ((x < 4 if asset.variant.ends_with("w") else x >= 12) and (y < 4 if asset.variant.begins_with("n") else y >= 12))
			if inside:
				image.set_pixel(x, y, road.get_pixel(x, y))
	return image


func _building(asset: Dictionary, colors: Dictionary) -> Image:
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(colors.B)
	var v: String = asset.variant
	match asset.kind:
		"roof":
			image.fill(Color.TRANSPARENT)
			for y in range(16):
				for x in range(16):
					var left: int = (4 if y < 3 and v.contains("top") else 2) if v.contains("left") else 0
					var right: int = (12 if y < 3 and v.contains("top") else 14) if v.contains("right") else 16
					if x >= left and x < right and not (v.contains("top") and y == 0):
						var groove: int = (x + (4 if y % 8 >= 4 else 0)) % 8
						var color: Color = colors.W if y % 4 == 3 else colors.R
						if groove == 0:
							color = colors.D
						elif y % 4 == 0 or groove == 1:
							color = colors.M
						image.set_pixel(x, y, color)
			if v == "worn":
				image.fill_rect(Rect2i(5, 6, 4, 2), colors.W)
				image.fill_rect(Rect2i(10, 12, 3, 2), colors.D)
		"eave":
			image.fill_rect(Rect2i(0, 0, 16, 8), colors.R)
			for x in range(1, 16, 4):
				image.fill_rect(Rect2i(x, 0, 1, 8), colors.M)
			image.fill_rect(Rect2i(0, 8, 16, 4), colors.D)
			image.fill_rect(Rect2i(0, 9, 16, 1), colors.W)
		"wall":
			if v == "timber":
				image.fill(colors.W)
				for x in [0, 5, 10, 15]:
					image.fill_rect(Rect2i(x, 0, 1, 16), colors.D)
			elif v == "brick":
				image.fill(colors.D)
				for y in range(0, 16, 4):
					for x in range(-4 if y % 8 else 0, 16, 8):
						image.fill_rect(Rect2i(x, y, 7, 3).intersection(Rect2i(0, 0, 16, 16)), colors.R)
			else:
				image.fill_rect(Rect2i(3, 7, 2, 1), colors.W)
				if v in ["aged", "patch"]:
					image.fill_rect(Rect2i(5, 10, 7, 4), colors.W)
					image.fill_rect(Rect2i(8, 11, 2, 2), colors.R)
				if v in ["left", "right"]:
					image.fill_rect(Rect2i(0 if v == "left" else 14, 0, 2, 16), colors.W)
		"door":
			var colonial := v.begins_with("colonial")
			image.fill_rect(Rect2i(2, 0, 12, 16), colors.C if colonial else colors.D)
			image.fill_rect(Rect2i(4, 0, 8, 16), colors.W)
			for x in [5, 8, 11]:
				image.fill_rect(Rect2i(x, 0, 1, 16), colors.D)
			if v.ends_with("top"):
				image.fill_rect(Rect2i(4, 0, 8, 2), colors.D)
				image.set_pixel(10, 12, colors.B)
			else:
				image.fill_rect(Rect2i(2, 14, 12, 2), colors.D)
		"window":
			if v == "booth":
				image.fill(colors.W)
			image.fill_rect(Rect2i(2, 3, 12, 11), colors.W)
			image.fill_rect(Rect2i(4, 4, 8, 8), colors.D)
			if v == "shutter":
				for y in range(4, 12, 2):
					image.fill_rect(Rect2i(4, y, 8, 1), colors.O)
			elif v == "vent":
				for x in range(4, 12, 3):
					image.fill_rect(Rect2i(x, 4, 1, 8), colors.B)
			else:
				image.fill_rect(Rect2i(5, 5, 2, 5), colors.M)
				image.fill_rect(Rect2i(5, 5, 1, 3), colors.C)
				image.fill_rect(Rect2i(7, 4, 1, 8), colors.C if v == "colonial" else colors.B)
				image.fill_rect(Rect2i(4, 8, 8, 1), colors.W)
		"foundation":
			image.fill_rect(Rect2i(0, 11, 16, 3), colors.W)
			image.fill_rect(Rect2i(0, 14, 16, 2), colors.D)
			if v == "aged":
				image.fill_rect(Rect2i(2, 5, 6, 3), colors.W)
		"pillar":
			image.fill(colors.C)
			image.fill_rect(Rect2i(11, 0, 5, 16), colors.B)
			image.fill_rect(Rect2i(0, 13, 16, 3), colors.W)
		"step":
			image.fill(colors.W)
			for y in [0, 5, 10]:
				image.fill_rect(Rect2i(0, y, 16, 2), colors.B)
		"post":
			image.fill(Color.TRANSPARENT)
			image.fill_rect(Rect2i(2 if v == "left" else 10, 0, 4, 16), colors.D)
			image.fill_rect(Rect2i(3 if v == "left" else 11, 0, 1, 16), colors.W)
	return image


func _object(asset: Dictionary, colors: Dictionary) -> Image:
	var image := Image.create(int(asset.size[0]), int(asset.size[1]), false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	for op in asset.ops:
		if op.type == "rect":
			image.fill_rect(Rect2i(int(op.rect[0]), int(op.rect[1]), int(op.rect[2]), int(op.rect[3])), colors[op.color])
		else:
			var points := PackedVector2Array()
			for point in op.points:
				points.append(Vector2(point[0], point[1]))
			for y in range(image.get_height()):
				for x in range(image.get_width()):
					if Geometry2D.is_point_in_polygon(Vector2(x + 0.5, y + 0.5), points):
						image.set_pixel(x, y, colors[op.color])
	return image


func _write_text(path: String, text: String, check_only: bool) -> void:
	if check_only:
		if not FileAccess.file_exists(path) or FileAccess.get_file_as_string(path) != text:
			failed = true
			printerr("FAIL: Metadata berbeda: ", path)
		return
	var error := DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	if error != OK:
		failed = true
		return
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		failed = true
		return
	file.store_string(text)
	file.flush()
	failed = failed or file.get_error() != OK


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 1 or (args.size() == 1 and args[0] != "--check"):
		_abort("Gunakan tanpa argumen atau -- --check.")
		return
	var check_only := args.has("--check")
	var palette: Variant = JSON.parse_string(FileAccess.get_file_as_string(PALETTE_SOURCE))
	var error := Foundation.validate_palette(palette)
	if not error.is_empty():
		_abort(error)
		return
	var colors := {".": Color.TRANSPARENT}
	for entry in palette.colors:
		colors[entry.symbol] = Color(entry.hex)
	var source: Variant = JSON.parse_string(FileAccess.get_file_as_string(TILE_SOURCE))
	var layout: Variant = JSON.parse_string(FileAccess.get_file_as_string(MAP_SOURCE))
	error = validate_tiles(source, layout, colors)
	if not error.is_empty():
		_abort(error)
		return
	var manifest := {"version": 1, "generator": "tools/generate_tilesets.gd", "source": TILE_SOURCE.trim_prefix("res://"), "palette": PALETTE_SOURCE.trim_prefix("res://"), "tile_size": [16, 16], "margin": [1, 1], "separation": [2, 2], "padding": 1, "filter": "nearest", "mask_bits": source.mask_bits, "atlases": {}, "blueprints": source.blueprints, "integrated": false}
	var images: Dictionary = {}
	var atlases: Dictionary = {}
	var index_text := "# Indeks tile atlas\n\nDibuat ulang oleh tools/generate_tilesets.gd. Koordinat dari kiri atas, nol-based. Konten 16x16 berada pada (1+18x,1+18y). Semua padding adalah ekstrusi 1 px.\n\n"
	for group in ["terrain", "buildings", "environment"]:
		var row_count: int = {"terrain": 5, "buildings": 4, "environment": 6}[group]
		var atlas := Image.create(144, row_count * 18, false, Image.FORMAT_RGBA8)
		atlas.fill(Color.TRANSPARENT)
		var entries: Array = []
		index_text += "## " + group + "\n\n| ID | Ukuran objek | Sel atlas | Pixel region konten | Offset objek |\n|---|---|---|---|---|\n"
		for i in range(source[group].size()):
			var asset: Dictionary = source[group][i]
			var image: Image = _terrain(asset, colors) if group == "terrain" else (_building(asset, colors) if group == "buildings" else _object(asset, colors))
			images[group + "/" + asset.id] = image
			var origin := Vector2i(i % 8, i / 8) if group != "environment" else Vector2i(asset.cell[0], asset.cell[1])
			var cells: Array = []
			for y in range(image.get_height() / 16):
				for x in range(image.get_width() / 16):
					var cell := origin + Vector2i(x, y)
					var pos := cell * 18 + Vector2i.ONE
					var tile := image.get_region(Rect2i(x * 16, y * 16, 16, 16))
					for py in range(-1, 17):
						for px in range(-1, 17):
							atlas.set_pixelv(pos + Vector2i(px, py), tile.get_pixel(clampi(px, 0, 15), clampi(py, 0, 15)))
					cells.append({"atlas": [cell.x, cell.y], "pixel_region": [pos.x, pos.y, 16, 16], "offset_px": [x * 16, y * 16]})
					index_text += "| " + asset.id + " | " + str(image.get_width()) + "x" + str(image.get_height()) + " | " + str(cell) + " | " + str(pos) + ",16,16 | " + str(Vector2i(x * 16, y * 16)) + " |\n"
			entries.append({"id": asset.id, "name": asset.get("name", asset.id.replace("_", " ")), "size_px": [image.get_width(), image.get_height()], "cells": cells, "assembly": "16px_cells", "kind": asset.get("kind", "object"), "variant": asset.get("variant", ""), "mask": int(asset.get("mask", -1)), "opaque": image.detect_alpha() == Image.ALPHA_NONE})
		var path: String = TILE_OUTPUT + group + "_16.png"
		_output_image(path, atlas, check_only)
		atlases[group] = atlas
		manifest.atlases[group] = {"path": path.trim_prefix("res://"), "size_px": [144, row_count * 18], "grid_size": [8, row_count], "assets": entries}
	_output_image(TILE_DOCS + "contact_sheet.png", _contact(atlases, manifest, colors), check_only)
	var preview := _preview(images, source.blueprints, layout)
	_output_image(TILE_DOCS + "map_preview.png", preview, check_only)
	preview.resize(1536, 960, Image.INTERPOLATE_NEAREST)
	_output_image(TILE_DOCS + "map_preview_3x.png", preview, check_only)
	_write_text(TILE_OUTPUT + "manifest.json", JSON.stringify(manifest, "  ", true) + "\n", check_only)
	_write_text(TILE_DOCS + "tile_index.md", index_text, check_only)
	print("TILESET_GENERATOR_RESULT mode=", "check" if check_only else "generate", " png=6 cells=120 objects=97 failures=", int(failed))
	quit(1 if failed else 0)


func _contact(atlases: Dictionary, manifest: Dictionary, colors: Dictionary) -> Image:
	var canvas := Image.create(832, 1536, false, Image.FORMAT_RGBA8)
	canvas.fill(colors.D)
	_text(canvas, "TILESET / BANDUNG 1946", Vector2i(24, 18), colors.C, 2)
	_text(canvas, "KONTEN 16X16 / PREVIEW 3X NEAREST / PADDING TIDAK DITAMPILKAN", Vector2i(24, 44), colors.B)
	var top := 64
	for group in ["terrain", "buildings", "environment"]:
		_text(canvas, group.to_upper(), Vector2i(24, top), colors.C, 2)
		top += 24
		for asset in manifest.atlases[group].assets:
			for cell in asset.cells:
				var point := Vector2i(cell.atlas[0], cell.atlas[1])
				var at := Vector2i(32 + point.x * 96, top + point.y * 88)
				for y in range(6):
					for x in range(6):
						canvas.fill_rect(Rect2i(at + Vector2i(16 + x * 8, y * 8), Vector2i(8, 8)), colors.W if (x + y) % 2 == 0 else colors.B)
				var tile: Image = atlases[group].get_region(Rect2i(1 + point.x * 18, 1 + point.y * 18, 16, 16))
				tile.resize(48, 48, Image.INTERPOLATE_NEAREST)
				canvas.blend_rect(tile, Rect2i(0, 0, 48, 48), at + Vector2i(16, 0))
				_text(canvas, str(point.x) + "/" + str(point.y), at + Vector2i(16, 54), colors.C)
				_text(canvas, asset.id.replace("_", "-").to_upper().substr(0, 14), at + Vector2i(2, 66), colors.B)
		top += int(manifest.atlases[group].grid_size[1]) * 88 + 24
	return canvas


func _preview(images: Dictionary, blueprints: Array, layout: Dictionary) -> Image:
	var canvas := Image.create(512, 320, false, Image.FORMAT_RGBA8)
	for y in range(20):
		for x in range(32):
			var id := "grass"
			var horizontal := y >= 9 and y <= 12
			var vertical := x >= 14 and x <= 17
			if horizontal or vertical:
				id = "road_dust" if (x + y) % 3 == 0 else "road_dirt"
				if horizontal and not vertical:
					if y == 9 or y == 12:
						id = "road_edge_n" if y == 9 else "road_edge_s"
					elif x >= 20 and x <= 29:
						id = "cobble" if x % 2 == 0 else "cobble_worn"
				elif vertical and not horizontal and (x == 14 or x == 17):
					id = "road_edge_w" if x == 14 else "road_edge_e"
				if horizontal and vertical:
					if x == 14 and y == 9:
						id = "road_inner_nw"
					elif x == 17 and y == 9:
						id = "road_inner_ne"
					elif x == 14 and y == 12:
						id = "road_inner_sw"
					elif x == 17 and y == 12:
						id = "road_inner_se"
			elif (x >= 2 and x <= 8 and y >= 1 and y <= 8) or (x >= 21 and x <= 29 and y <= 8) or (x >= 2 and x <= 8 and y >= 14) or (x >= 22 and x <= 27 and y >= 14):
				id = "dry_soil" if (x + y * 3) % 7 == 0 else ("soil" if (x + y) % 2 else "soil_pebbles")
			canvas.blit_rect(images["terrain/" + id], Rect2i(0, 0, 16, 16), Vector2i(x * 16, y * 16))
			if id == "grass" and (x * 3 + y * 7) % 19 == 0:
				canvas.blend_rect(images["terrain/deco_fallen_leaves"], Rect2i(0, 0, 16, 16), Vector2i(x * 16, y * 16))
	var structures: Dictionary = {}
	for building in blueprints:
		var image := Image.create(building.rows[0].size() * 16, building.rows.size() * 16, false, Image.FORMAT_RGBA8)
		image.fill(Color.TRANSPARENT)
		for y in range(building.rows.size()):
			for x in range(building.rows[y].size()):
				image.blend_rect(images["buildings/" + building.rows[y][x]], Rect2i(0, 0, 16, 16), Vector2i(x * 16, y * 16))
		structures[building.id] = image
	var placements: Array = []
	for group in ["buildings", "environment"]:
		for item in layout[group]:
			var image: Image = structures[item.id] if group == "buildings" else images["environment/" + item.id]
			placements.append({"image": image, "at": Vector2i(item.at[0], item.at[1]) * 16})
	placements.sort_custom(func(a, b): return a.at.y + a.image.get_height() < b.at.y + b.image.get_height())
	for item in placements:
		canvas.blend_rect(item.image, Rect2i(Vector2i.ZERO, item.image.get_size()), item.at)
	return canvas
