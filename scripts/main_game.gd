extends Node2D

@onready var pause_panel: Control = $UI/Pause
@onready var resume_button: Button = $UI/Pause/Center/Panel/Margin/Content/Resume


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not event.is_echo():
		_set_paused(not get_tree().paused)
		get_viewport().set_input_as_handled()


func _set_paused(value: bool) -> void:
	get_tree().paused = value
	pause_panel.visible = value
	if value:
		resume_button.grab_focus()
	else:
		get_viewport().gui_release_focus()


func _on_resume_pressed() -> void:
	_set_paused(false)


func _on_restart_pressed() -> void:
	# shortcut: restart seluruh map pada Phase 1; gunakan area aktif setelah sistem misi tersedia.
	_set_paused(false)
	_handle_scene_error(get_tree().reload_current_scene())


func _on_main_menu_pressed() -> void:
	_set_paused(false)
	_handle_scene_error(get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))


func _handle_scene_error(error: Error) -> void:
	if error != OK:
		_set_paused(true)
		$UI/Pause/Center/Panel/Margin/Content/Status.text = "Scene gagal dimuat. Periksa berkas proyek."
		push_error("Gagal berpindah scene: " + error_string(error))
