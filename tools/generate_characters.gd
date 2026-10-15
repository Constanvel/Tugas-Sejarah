extends "res://tools/generate_assets.gd"

const Foundation = preload("res://tools/generate_assets.gd")
const CHARACTER_SOURCE := "res://assets/art_sources/characters.json"
const CHARACTER_OUTPUT := "res://assets/sprites/characters/"
const PREVIEWS := "res://docs/art/characters/"
const ROWS := ["down", "left", "right", "up"]
const COLUMNS := ["idle", "walk_a", "walk_b"]


static func frame_rows(view: Dictionary, pose: String) -> Array:
	var rows: Array = view.idle.duplicate()
	if pose != "idle":
		for y in view[pose]:
			rows[int(y)] = view[pose][y]
	return rows


static func sample_for(rows: Array) -> Dictionary:
	return {"id": "frame", "category": "characters", "size": [16, 24], "frame_size": [16, 24], "frames": 1, "directions": ["fixed"], "pivot": [8, 23], "transparent": true, "rows": rows}


static func validate_characters(source: Variant, colors: Dictionary) -> String:
	if not source is Dictionary or source.get("row_order") != ROWS or source.get("column_order") != COLUMNS:
		return "Urutan atlas harus Down/Left/Right/Up dan Idle/Walk A/Walk B."
	if source.get("frame_size") != [16.0, 24.0] or source.get("pivot") != [8.0, 23.0] or source.get("foot_baseline_y") != 22:
		return "Frame 16x24, pivot (8,23) dan garis kaki y=22 wajib dipertahankan."
	if not source.get("characters") is Array or source.characters.size() != 3:
		return "Sumber harus berisi tepat tiga karakter."
	for index in range(3):
		var actor: Variant = source.characters[index]
		var expected_id: String = ["player", "enemy", "civilian"][index]
		if not actor is Dictionary or actor.get("id") != expected_id or actor.get("animated") != (index < 2) or not actor.get("views") is Dictionary:
			return "ID, urutan atau status animasi karakter tidak sesuai."
		if not actor.get("name") is String or actor.name.is_empty() or not actor.get("function") is String or actor.function.is_empty():
			return "Nama dan fungsi karakter wajib diisi sebelum menulis aset."
		var directions: Array = ROWS if actor.animated else ["down"]
		if actor.views.size() != directions.size():
			return "Jumlah arah karakter tidak sesuai."
		for direction in directions:
			var view: Variant = actor.views.get(direction)
			if not view is Dictionary or not view.get("idle") is Array:
				return "Setiap arah harus memiliki piksel idle."
			var error := Foundation.validate_sample(sample_for(view.idle), colors)
			if not error.is_empty():
				return actor.id + "/" + direction + ": " + error
			for pose in COLUMNS if actor.animated else ["idle"]:
				if pose != "idle":
					if not view.get(pose) is Dictionary or view[pose].is_empty():
						return "Langkah wajib memiliki variasi piksel."
					for y in view[pose]:
						if not y is String or not y.is_valid_int() or str(int(y)) != y or int(y) < 9 or int(y) > 22:
							return "Perubahan langkah hanya boleh pada baris tubuh/kaki 9..22."
				var data := sample_for(frame_rows(view, pose))
				error = Foundation.validate_sample(data, colors)
				if not error.is_empty():
					return actor.id + "/" + direction + "/" + pose + ": " + error
				var frame := Foundation.render_sample(data, colors)
				var bounds := frame.get_used_rect()
				if not bounds.has_area() or not Rect2i(1, 1, 14, 22).encloses(bounds) or bounds.end.y != 23:
					return "Frame wajib memiliki margin transparan dan kaki pada y=22."
	return ""


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
	var source: Variant = JSON.parse_string(FileAccess.get_file_as_string(CHARACTER_SOURCE))
	error = validate_characters(source, colors)
	if not error.is_empty():
		_abort(error)
		return
	var entries: Array = []
	var previews: Array[Image] = []
	for actor in source.characters:
		var columns: int = 3 if actor.animated else 1
		var row_count: int = 4 if actor.animated else 1
		var sheet := Image.create(16 * columns, 24 * row_count, false, Image.FORMAT_RGBA8)
		sheet.fill(Color.TRANSPARENT)
		for row in range(row_count):
			for col in range(columns):
				var frame := Foundation.render_sample(sample_for(frame_rows(actor.views[ROWS[row]], COLUMNS[col])), colors)
				sheet.blit_rect(frame, Rect2i(0, 0, 16, 24), Vector2i(col * 16, row * 24))
		_output_image(CHARACTER_OUTPUT + actor.id + ".png", sheet, check_only)
		var preview := sheet.duplicate() as Image
		preview.resize(sheet.get_width() * 8, sheet.get_height() * 8, Image.INTERPOLATE_NEAREST)
		previews.append(preview)
		_output_image(PREVIEWS + actor.id + "_8x.png", preview, check_only)
		entries.append({"id": actor.id, "name": actor.name, "function": actor.function, "path": "assets/sprites/characters/" + actor.id + ".png", "size": [sheet.get_width(), sheet.get_height()], "frame_size": [16, 24], "frames": columns * row_count, "columns": columns, "rows": row_count, "directions": ROWS if actor.animated else ["down"], "poses": COLUMNS if actor.animated else ["idle"], "pivot": [8, 23], "foot_baseline_y": 22, "transparent": true, "filter": "nearest", "preview": "docs/art/characters/" + actor.id + "_8x.png", "preview_scale": 8, "integrated": false})
	_output_image(PREVIEWS + "contact_sheet.png", _contact_sheet(previews, colors), check_only)
	var manifest := {"version": 1, "source": CHARACTER_SOURCE.trim_prefix("res://"), "generator": "tools/generate_characters.gd", "palette": PALETTE_SOURCE.trim_prefix("res://"), "frame_size": [16, 24], "pivot": [8, 23], "foot_baseline_y": 22, "row_order": ROWS, "column_order": COLUMNS, "assets": entries}
	var text := JSON.stringify(manifest, "  ", true) + "\n"
	var manifest_path := CHARACTER_OUTPUT + "manifest.json"
	if check_only:
		if not FileAccess.file_exists(manifest_path) or FileAccess.get_file_as_string(manifest_path) != text:
			failed = true
			printerr("FAIL: Manifest karakter berbeda dari sumber.")
	else:
		var file := FileAccess.open(manifest_path, FileAccess.WRITE)
		if file == null:
			_abort("Tidak dapat menulis manifest karakter.")
			return
		file.store_string(text)
		file.flush()
		failed = failed or file.get_error() != OK
	print("CHARACTER_GENERATOR_RESULT mode=", "check" if check_only else "generate", " png=7 failures=", int(failed))
	quit(1 if failed else 0)


func _contact_sheet(previews: Array[Image], colors: Dictionary) -> Image:
	var canvas := Image.create(960, 1120, false, Image.FORMAT_RGBA8)
	canvas.fill(colors.D)
	_text(canvas, "KARAKTER / BANDUNG 1946", Vector2i(24, 16), colors.C, 2)
	_text(canvas, "FRAME 16X24 / PRATINJAU 8X NEAREST / GARIS ORANYE: DASAR KAKI", Vector2i(24, 42), colors.B)
	for actor in range(2):
		var x := 72 + actor * 448
		_text(canvas, "PEJUANG" if actor == 0 else "LAWAN FIKTIF", Vector2i(x, 64), colors.C, 2)
		for col in range(3):
			_text(canvas, ["DIAM", "LANGKAH A", "LANGKAH B"][col], Vector2i(x + col * 128 + 8, 88), colors.B, 2)
		for row in range(4):
			_text(canvas, ["BAWAH", "KIRI", "KANAN", "ATAS"][row], Vector2i(x - 52, 116 + row * 192), colors.C)
			for col in range(3):
				var cell := Vector2i(x + col * 128, 112 + row * 192)
				for y in range(24):
					for tile_x in range(16):
						canvas.fill_rect(Rect2i(cell + Vector2i(tile_x * 8, y * 8), Vector2i(8, 8)), colors.W if (tile_x + y) % 2 == 0 else colors.B)
				canvas.fill_rect(Rect2i(cell.x, cell.y + 184, 128, 1), colors.M)
		canvas.blend_rect(previews[actor], Rect2i(Vector2i.ZERO, previews[actor].get_size()), Vector2i(x, 112))
	_text(canvas, "WARGA / SATU POSE", Vector2i(24, 900), colors.C, 2)
	canvas.fill_rect(Rect2i(72, 924, 128, 192), colors.W)
	canvas.blend_rect(previews[2], Rect2i(0, 0, 128, 192), Vector2i(72, 924))
	_text(canvas, "PALET TUJUH WARNA / ALPHA 0 ATAU 255", Vector2i(240, 952), colors.C, 2)
	_text(canvas, "TANPA INSIGNIA / TANPA SENJATA / BELUM TERPASANG", Vector2i(240, 980), colors.B)
	_text(canvas, "URUTAN LOOP JALAN: A - B / IDLE TERPISAH", Vector2i(240, 1000), colors.B)
	_text(canvas, "KARAKTER FIKTIF / BUKAN REKONSTRUKSI SERAGAM TERTENTU", Vector2i(240, 1020), colors.B)
	return canvas
