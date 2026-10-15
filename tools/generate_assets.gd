extends SceneTree

const PALETTE_SOURCE := "res://assets/art_sources/palette.json"
const SAMPLE_SOURCE := "res://assets/art_sources/foundation_samples.json"
const OUTPUT := "res://assets/generated/"
const GUIDE := "res://docs/art/style_guide.png"
const FONT := {
	"A": [14,17,17,31,17,17,17], "B": [30,17,17,30,17,17,30], "C": [14,17,16,16,16,17,14],
	"D": [30,17,17,17,17,17,30], "E": [31,16,16,30,16,16,31], "F": [31,16,16,30,16,16,16],
	"G": [14,17,16,23,17,17,14], "H": [17,17,17,31,17,17,17], "I": [14,4,4,4,4,4,14],
	"J": [7,2,2,2,2,18,12], "K": [17,18,20,24,20,18,17], "L": [16,16,16,16,16,16,31],
	"M": [17,27,21,21,17,17,17], "N": [17,25,21,19,17,17,17], "O": [14,17,17,17,17,17,14],
	"P": [30,17,17,30,16,16,16], "Q": [14,17,17,17,21,18,13], "R": [30,17,17,30,20,18,17],
	"S": [15,16,16,14,1,1,30], "T": [31,4,4,4,4,4,4], "U": [17,17,17,17,17,17,14],
	"V": [17,17,17,17,17,10,4], "W": [17,17,17,21,21,21,10], "X": [17,17,10,4,10,17,17],
	"Y": [17,17,10,4,4,4,4], "Z": [31,1,2,4,8,16,31],
	"0": [14,17,19,21,25,17,14], "1": [4,12,4,4,4,4,14], "2": [14,17,1,2,4,8,31],
	"3": [30,1,1,14,1,1,30], "4": [2,6,10,18,31,2,2], "5": [31,16,16,30,1,1,30],
	"6": [14,16,16,30,17,17,14], "7": [31,1,2,4,8,8,8], "8": [14,17,17,14,17,17,14],
	"9": [14,17,17,15,1,1,14], " ": [0,0,0,0,0,0,0], "/": [1,1,2,4,8,16,16],
	"-": [0,0,0,31,0,0,0], ":": [0,4,4,0,4,4,0], "#": [10,31,10,10,31,10,0]
}

var failed: bool = false


func _initialize() -> void:
	_run.call_deferred()


static func validate_palette(data: Variant) -> String:
	if not data is Dictionary or not data.get("colors") is Array or data.colors.size() != 7:
		return "Palet harus memuat tujuh warna."
	var symbols: Array = []
	var values: Array = []
	for entry in data.colors:
		if not entry is Dictionary or not entry.get("symbol") is String or not entry.get("hex") is String:
			return "Entri warna tidak valid."
		if entry.symbol.length() != 1 or entry.symbol == "." or entry.symbol in symbols:
			return "Simbol warna harus unik dan satu karakter."
		if entry.hex.length() != 7 or not entry.hex.begins_with("#") or not entry.hex.substr(1).is_valid_hex_number():
			return "Warna harus menggunakan format #RRGGBB."
		if entry.hex.to_upper() in values:
			return "Nilai warna harus unik."
		symbols.append(entry.symbol)
		values.append(entry.hex.to_upper())
	for required in "DWBOMRC":
		if required not in symbols:
			return "Pertahankan simbol D/W/B/O/M/R/C yang digunakan style guide."
	return ""


static func validate_sample(sample: Variant, colors: Dictionary) -> String:
	if not sample is Dictionary or not sample.get("id") is String or not sample.id.is_valid_identifier():
		return "ID sampel harus berupa identifier tanpa path."
	if sample.get("category") not in ["characters", "props", "tiles"]:
		return "Kategori sampel tidak didukung."
	var size: Variant = sample.get("size")
	if not size is Array or size.size() != 2:
		return "Dimensi sampel wajib berisi lebar dan tinggi."
	for value in size:
		if not (value is int or value is float) or value != int(value) or value < 1 or value > 256:
			return "Dimensi harus bilangan bulat positif maksimal 256."
	if sample.get("frame_size") != size or sample.get("frames") != 1:
		return "Fondasi hanya mendukung satu frame per PNG."
	if sample.category == "characters" and (int(size[0]) != 16 or int(size[1]) != 24):
		return "Frame karakter wajib 16x24."
	if sample.category == "tiles" and (int(size[0]) != 16 or int(size[1]) != 16):
		return "Tile wajib 16x16."
	if not sample.get("transparent") is bool:
		return "Status transparansi wajib boolean."
	if not sample.get("directions") is Array or sample.directions.is_empty():
		return "Arah sampel wajib dicatat."
	var pivot: Variant = sample.get("pivot")
	if not pivot is Array or pivot.size() != 2:
		return "Pivot wajib dicatat."
	for axis in range(2):
		if not (pivot[axis] is float or pivot[axis] is int) or pivot[axis] < 0 or pivot[axis] > size[axis] or pivot[axis] != int(pivot[axis]):
			return "Pivot harus berada dalam batas frame."
	if sample.has("rows") == sample.has("rects"):
		return "Pilih satu sumber gambar: rows atau rects."
	if sample.has("rows"):
		if not sample.rows is Array or sample.rows.size() != int(size[1]):
			return "Jumlah baris piksel tidak sesuai tinggi."
		for row in sample.rows:
			if not row is String or row.length() != int(size[0]):
				return "Lebar baris piksel tidak sesuai frame."
			for symbol in row:
				if not colors.has(symbol):
					return "Simbol piksel tidak terdapat pada palet."
	else:
		if not sample.rects is Array or sample.rects.is_empty():
			return "Daftar bidang gambar kosong."
		for rect in sample.rects:
			if not rect is Array or rect.size() != 5 or not colors.has(rect[4]):
				return "Bidang gambar harus memuat empat koordinat dan satu simbol warna."
			for i in range(4):
				if not (rect[i] is int or rect[i] is float) or rect[i] != int(rect[i]):
					return "Koordinat bidang harus berupa bilangan bulat."
			if rect[0] < 0 or rect[1] < 0 or rect[2] <= 0 or rect[3] <= 0 or rect[0] + rect[2] > size[0] or rect[1] + rect[3] > size[1]:
				return "Bidang gambar berada di luar frame."
	return ""


static func render_sample(sample: Dictionary, colors: Dictionary) -> Image:
	var result := Image.create(int(sample.size[0]), int(sample.size[1]), false, Image.FORMAT_RGBA8)
	result.fill(Color.TRANSPARENT)
	if sample.has("rows"):
		for y in range(sample.rows.size()):
			for x in range(sample.rows[y].length()):
				result.set_pixel(x, y, colors[sample.rows[y][x]])
	else:
		for rect in sample.rects:
			result.fill_rect(Rect2i(int(rect[0]), int(rect[1]), int(rect[2]), int(rect[3])), colors[rect[4]])
	return result


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 1 or (args.size() == 1 and args[0] != "--check"):
		printerr("Gunakan tanpa argumen untuk generate, atau -- --check untuk validasi.")
		quit(1)
		return
	var check_only := args.has("--check")
	var palette: Variant = JSON.parse_string(FileAccess.get_file_as_string(PALETTE_SOURCE))
	var error := validate_palette(palette)
	if not error.is_empty():
		_abort(error)
		return
	var colors := {".": Color.TRANSPARENT}
	for entry in palette.colors:
		colors[entry.symbol] = Color(entry.hex)
	var source: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAMPLE_SOURCE))
	if not source is Dictionary or not source.get("samples") is Array or source.samples.size() != 3:
		_abort("Fondasi memerlukan tepat tiga studi, bukan paket aset lengkap.")
		return
	var ids: Array = []
	for sample in source.samples:
		error = validate_sample(sample, colors)
		if not error.is_empty():
			_abort(error)
			return
		if sample.id in ids:
			_abort("ID sampel duplikat.")
			return
		ids.append(sample.id)
	if ids != ["courier_idle_south", "wooden_crate", "dirt_tile"]:
		_abort("Studi fondasi berubah; perbarui komposisi style guide dan tes saat menambah kategori.")
		return
	var entries: Array = []
	var samples: Array[Image] = []
	for sample in source.samples:
		var image := render_sample(sample, colors)
		samples.append(image)
		var path: String = OUTPUT + sample.category + "/" + sample.id + ".png"
		_output_image(path, image, check_only)
		var entry: Dictionary = sample.duplicate(true)
		entry.erase("rows")
		entry.erase("rects")
		entry.merge({"path": path.trim_prefix("res://"), "filter": "nearest", "status": "style_study", "integrated": false, "production_ready": false})
		entries.append(entry)
	var strip := Image.create(7, 1, false, Image.FORMAT_RGBA8)
	for i in range(7):
		strip.set_pixel(i, 0, colors[palette.colors[i].symbol])
	_output_image(OUTPUT + "palette.png", strip, check_only)
	entries.append({"id": "palette", "path": "assets/generated/palette.png", "size": [7, 1], "frame_size": [1, 1], "frames": 7, "category": "palette", "transparent": false, "function": "Tujuh swatch warna PRD"})
	_output_image(GUIDE, _guide(samples, palette.colors, colors), check_only)
	entries.append({"id": "style_guide", "path": GUIDE.trim_prefix("res://"), "size": [640, 360], "frame_size": [640, 360], "frames": 1, "category": "documentation", "transparent": false, "function": "Preview teknis dan contact sheet; bukan sprite dunia"})
	var manifest := {"version": 1, "generator": "tools/generate_assets.gd", "palette_source": PALETTE_SOURCE.trim_prefix("res://"), "samples_source": SAMPLE_SOURCE.trim_prefix("res://"), "tile_size": [16, 16], "character_frame": [16, 24], "reference_resolution": [640, 360], "filter": "nearest", "assets": entries}
	var manifest_text := JSON.stringify(manifest, "  ", true) + "\n"
	if check_only:
		if not FileAccess.file_exists(OUTPUT + "manifest.json") or FileAccess.get_file_as_string(OUTPUT + "manifest.json") != manifest_text:
			failed = true
			printerr("FAIL: Manifest berbeda dari sumber. Jalankan generator.")
	else:
		var file := FileAccess.open(OUTPUT + "manifest.json", FileAccess.WRITE)
		if file == null:
			_abort("Manifest tidak dapat ditulis.")
			return
		file.store_string(manifest_text)
		file.flush()
		if file.get_error() != OK:
			failed = true
	print("ASSET_GENERATOR_RESULT mode=", "check" if check_only else "generate", " png=5 failures=", int(failed))
	quit(1 if failed else 0)


func _abort(message: String) -> void:
	printerr("FAIL: ", message)
	quit(1)


func _output_image(path: String, image: Image, check_only: bool) -> void:
	if check_only:
		var saved := Image.new()
		if not FileAccess.file_exists(path) or saved.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) != OK or saved.get_size() != image.get_size() or saved.get_data() != image.get_data():
			failed = true
			printerr("FAIL: PNG berbeda dari sumber: ", path)
	else:
		var error := DirAccess.make_dir_recursive_absolute(path.get_base_dir())
		if error == OK:
			error = image.save_png(path)
		if error != OK:
			failed = true
			printerr("FAIL: Tidak dapat menyimpan ", path, ": ", error_string(error))


func _text(canvas: Image, text: String, at: Vector2i, color: Color, scale: int = 1) -> void:
	var cursor := at
	for letter in text:
		var glyph: Array = FONT.get(letter, FONT[" "])
		for y in range(7):
			for x in range(5):
				if int(glyph[y]) & (1 << (4 - x)):
					canvas.fill_rect(Rect2i(cursor.x + x * scale, cursor.y + y * scale, scale, scale), color)
		cursor.x += 6 * scale


func _guide(samples: Array[Image], swatches: Array, colors: Dictionary) -> Image:
	var canvas := Image.create(640, 360, false, Image.FORMAT_RGBA8)
	canvas.fill(colors.D)
	canvas.fill_rect(Rect2i(0, 0, 640, 4), colors.M)
	_text(canvas, "BANDUNG 1946 / PANDUAN ASET", Vector2i(24, 20), colors.C, 2)
	_text(canvas, "STUDI AWAL / BUKAN ASET FINAL / VIEWPORT 640X360", Vector2i(24, 46), colors.B)
	for i in range(7):
		var x := 24 + i * 84
		canvas.fill_rect(Rect2i(x, 70, 72, 32), colors.B)
		canvas.fill_rect(Rect2i(x + 1, 71, 70, 30), colors[swatches[i].symbol])
		_text(canvas, swatches[i].hex.to_upper(), Vector2i(x, 112), colors.C)
	var labels := ["KURIR / SELATAN", "PETI / ATAS-DEPAN", "TANAH / TOP-DOWN"]
	var dimensions := ["16X24 / 1 FRAME", "32X32 / 1 FRAME", "16X16 / BERULANG"]
	var scales := [4, 3, 6]
	for i in range(3):
		var x := 24 + i * 200
		canvas.fill_rect(Rect2i(x, 146, 184, 168), colors.W)
		_text(canvas, labels[i], Vector2i(x + 8, 154), colors.C)
		for y in range(13):
			for col in range(20):
				canvas.fill_rect(Rect2i(x + 12 + col * 8, 170 + y * 8, 8, 8), colors.W if (y + col) % 2 == 0 else colors.B)
		var enlarged := samples[i].duplicate() as Image
		enlarged.resize(samples[i].get_width() * scales[i], samples[i].get_height() * scales[i], Image.INTERPOLATE_NEAREST)
		canvas.blend_rect(enlarged, Rect2i(Vector2i.ZERO, enlarged.get_size()), Vector2i(x + (184 - enlarged.get_width()) / 2, 174))
		_text(canvas, dimensions[i], Vector2i(x + 8, 288), colors.C)
		_text(canvas, "PNG / NEAREST / STUDI", Vector2i(x + 8, 302), colors.B)
	_text(canvas, "CAHAYA KIRI ATAS / OUTLINE 1 PX / ALPHA 0 ATAU 255", Vector2i(24, 330), colors.C)
	_text(canvas, "TEKS HANYA PADA PANDUAN / SPRITE DUNIA TANPA TEKS", Vector2i(24, 344), colors.B)
	return canvas
