extends SceneTree


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	var error := change_scene_to_file("res://scenes/main_menu.tscn")
	if error != OK:
		quit(1)
		return
	await process_frame
	await process_frame
	var next_button := InputEventKey.new()
	next_button.keycode = KEY_TAB
	next_button.physical_keycode = KEY_TAB
	next_button.pressed = true
	Input.parse_input_event(next_button)
	await process_frame
	next_button.pressed = false
	Input.parse_input_event(next_button)
	await process_frame
	if not current_scene.get_node("Center/Panel/Margin/Content/Exit").has_focus():
		printerr("FAIL: Tab tidak memindahkan fokus ke tombol Keluar")
		quit(1)
		return
	print("EXIT_BUTTON_ACTIVATED")
	var accept := InputEventKey.new()
	accept.keycode = KEY_ENTER
	accept.physical_keycode = KEY_ENTER
	accept.pressed = true
	Input.parse_input_event(accept)
	await process_frame
	accept.pressed = false
	Input.parse_input_event(accept)
	await create_timer(3.0).timeout
	printerr("FAIL: Tombol Keluar tidak menghentikan aplikasi")
	quit(1)
