extends SceneTree

# Jalankan dengan renderer asli, bukan --headless, untuk menyimpan bukti visual.
var failures: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _frames() -> void:
	for frame in range(4):
		await process_frame
	await RenderingServer.frame_post_draw


func _capture(name: String) -> void:
	await _frames()
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		printerr("FAIL: Renderer tidak menyediakan gambar")
		failures += 1
		return
	var error := image.save_png("res://docs/qa/" + name + ".png")
	if error != OK:
		failures += 1
	print("CAPTURE ", name, " ", image.get_size(), " error=", error)


func _check_ui(node: Node) -> void:
	if node is Control and node.is_visible_in_tree():
		var control := node as Control
		if not Rect2(Vector2.ZERO, root.get_visible_rect().size).grow(1).encloses(control.get_global_rect()):
			printerr("FAIL: UI di luar viewport: ", control.get_path())
			failures += 1
		if control is Label and control.get_minimum_size().x > control.size.x + 1.0:
			printerr("FAIL: Teks terpotong: ", control.get_path())
			failures += 1
	for child in node.get_children():
		_check_ui(child)


func _run() -> void:
	DirAccess.make_dir_recursive_absolute("res://docs/qa")
	change_scene_to_file("res://scenes/main_menu.tscn")
	await _capture("main_menu")
	_check_ui(current_scene)
	print("WINDOW_SIZE ", DisplayServer.window_get_size())
	current_scene.get_node("Center/Panel/Margin/Content/Start").pressed.emit()
	await _capture("gameplay")
	_check_ui(current_scene.get_node("UI"))
	current_scene.get_node("Player").position = Vector2(800, 360)
	await _capture("area2")
	current_scene.get_node("Player").position = Vector2(1360, 360)
	await _capture("area3")
	var event := InputEventAction.new()
	event.action = "pause"
	event.pressed = true
	Input.parse_input_event(event)
	await _capture("pause")
	_check_ui(current_scene.get_node("UI"))
	paused = false
	DisplayServer.window_set_size(Vector2i(640, 360))
	change_scene_to_file("res://scenes/main_menu.tscn")
	await _capture("main_menu_640")
	_check_ui(current_scene)
	print("WINDOW_SIZE ", DisplayServer.window_get_size())
	print("VISUAL_RESULT failures=", failures)
	quit(1 if failures > 0 else 0)
