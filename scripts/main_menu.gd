extends Control

@onready var start_button: Button = $Center/Panel/Margin/Content/Start


func _ready() -> void:
	get_tree().paused = false
	start_button.grab_focus()


func _on_start_pressed() -> void:
	var error := get_tree().change_scene_to_file("res://scenes/main_game.tscn")
	if error != OK:
		$Center/Panel/Margin/Content/Status.text = "Map gagal dimuat. Periksa berkas proyek."
		push_error("Gagal membuka gameplay: " + error_string(error))


func _on_exit_pressed() -> void:
	get_tree().quit()
