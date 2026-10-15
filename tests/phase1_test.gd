extends SceneTree

var failures: int = 0
var checks: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _check(condition: bool, description: String) -> void:
	checks += 1
	if condition:
		print("PASS: ", description)
	else:
		failures += 1
		printerr("FAIL: ", description)


func _run() -> void:
	_check(ResourceLoader.exists("res://scenes/main_menu.tscn"), "Scene menu utama tersedia")
	if failures > 0:
		_finish()
		return
	await _test_game()
	_finish()


func _ticks(count: int) -> void:
	for tick in range(count):
		await physics_frame
		await process_frame


func _key(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)


func _test_game() -> void:
	for path in ["main_menu", "main_game", "player", "props/house", "props/tree", "props/crate"]:
		_check(load("res://scenes/" + path + ".tscn") is PackedScene, "Resource scene dapat dimuat: " + path)
	change_scene_to_file("res://scenes/main_menu.tscn")
	await _ticks(3)
	var menu: Control = current_scene
	var start: Button = menu.get_node("Center/Panel/Margin/Content/Start")
	_check(start.has_focus(), "Fokus keyboard awal berada pada tombol Mulai")
	_key(KEY_ENTER, true)
	await _ticks(2)
	_key(KEY_ENTER, false)
	await _ticks(4)
	_check(current_scene.scene_file_path == "res://scenes/main_game.tscn", "TC-01: Mulai membuka gameplay")
	var game: Node2D = current_scene
	var player: CharacterBody2D = game.get_node("Player")
	var player_script: Script = player.get_script()
	_check(player_script != null and player_script.can_instantiate(), "Script player valid dan dapat dijalankan")
	if failures > 0:
		return
	var spawn := player.position
	for sample in [[KEY_W, Vector2.UP], [KEY_A, Vector2.LEFT], [KEY_S, Vector2.DOWN], [KEY_D, Vector2.RIGHT]]:
		player.position = spawn
		_key(sample[0], true)
		await _ticks(30)
		_key(sample[0], false)
		await _ticks(2)
		var distance := player.position - spawn
		_check(distance.dot(sample[1]) > 45.0 and distance.dot(sample[1]) < 55.0, "TC-02: WASD bergerak 100 px/detik: " + OS.get_keycode_string(sample[0]))
	for pair in [[KEY_W, KEY_D, Vector2(1, -1)], [KEY_W, KEY_A, Vector2(-1, -1)], [KEY_S, KEY_D, Vector2(1, 1)], [KEY_S, KEY_A, Vector2(-1, 1)]]:
		player.position = spawn
		_key(pair[0], true)
		_key(pair[1], true)
		await _ticks(30)
		_key(pair[0], false)
		_key(pair[1], false)
		await _ticks(2)
		var diagonal := player.position - spawn
		_check(diagonal.length() > 45.0 and diagonal.length() < 55.0 and diagonal.sign() == pair[2], "Diagonal dinormalisasi: " + str(pair[2]))
	var stopped := player.position
	await _ticks(10)
	_check(player.position.is_equal_approx(stopped), "Pemain berhenti saat input dilepas")
	_key(KEY_A, true)
	_key(KEY_D, true)
	await _ticks(10)
	_key(KEY_A, false)
	_key(KEY_D, false)
	_check(player.position.is_equal_approx(stopped), "Input arah berlawanan saling meniadakan")
	player.position = Vector2(192, 280)
	_key(KEY_W, true)
	await _ticks(90)
	_key(KEY_W, false)
	_check(player.position.y >= 244.0 and player.position.y < 254.0, "TC-03: Rumah menghentikan player pada sisi bawah")
	player.position = Vector2(432, 276)
	_key(KEY_W, true)
	await _ticks(80)
	_key(KEY_W, false)
	_check(player.position.y >= 230.0 and player.position.y < 242.0, "Pohon memiliki collision pada batang")
	player.position = Vector2(720, 280)
	_key(KEY_W, true)
	await _ticks(80)
	_key(KEY_W, false)
	_check(player.position.y >= 244.0 and player.position.y < 254.0, "Peti memiliki collision")
	for edge in [[Vector2(40, 360), KEY_A, Vector2(21, 360)], [Vector2(1560, 360), KEY_D, Vector2(1579, 360)], [Vector2(800, 40), KEY_W, Vector2(800, 24)], [Vector2(800, 680), KEY_S, Vector2(800, 704)]]:
		player.position = edge[0]
		_key(edge[1], true)
		await _ticks(70)
		_key(edge[1], false)
		_check(player.position.distance_to(edge[2]) < 1.0, "Pemain mencapai dan berhenti di batas map: " + str(edge[2]))
	player.position = Vector2(300, 280)
	_key(KEY_W, true)
	_key(KEY_A, true)
	await _ticks(50)
	_check(player.get_slide_collision_count() > 0 and player.position.x >= 260.0 and player.position.y < 248.0, "Lintasan sudut benar-benar menyentuh sisi rumah")
	await _ticks(90)
	_key(KEY_W, false)
	_key(KEY_A, false)
	_check(player.position.x < 250.0 and player.position.y < 175.0, "Pemain meluncur pada sisi dan melewati sudut rumah")
	player.position = Vector2(800, 360)
	await _ticks(4)
	var camera: Camera2D = player.get_node("Camera2D")
	_check(camera.get_screen_center_position().distance_to(player.global_position) < 2.0, "Kamera mengikuti di tengah map")
	player.position = Vector2(40, 360)
	await _ticks(4)
	_check(camera.get_screen_center_position().x >= 320.0, "Kamera dibatasi agar tidak menampilkan luar map kiri")
	for edge in [[Vector2(1560, 360), Vector2(1280, 360)], [Vector2(800, 40), Vector2(800, 180)], [Vector2(800, 680), Vector2(800, 540)]]:
		player.position = edge[0]
		await _ticks(4)
		_check(camera.get_screen_center_position().distance_to(edge[1]) < 2.0, "Kamera dibatasi pada tepi map: " + str(edge[1]))
	player.position = spawn
	_key(KEY_D, true)
	await _ticks(780)
	_key(KEY_D, false)
	_check(player.position.x > 1480.0, "Jalan menghubungkan ketiga kawasan tanpa rintangan buntu")
	player.position = spawn
	_key(KEY_D, true)
	await _ticks(4)
	_check(player.position.x > spawn.x + 3.0, "Pemain bergerak sebelum pengujian kehilangan fokus")
	player.notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	await _ticks(3)
	_check(player.velocity.is_zero_approx(), "Kehilangan fokus melepas input agar gerak tidak tersangkut")
	_key(KEY_D, false)
	_key(KEY_ESCAPE, true)
	await _ticks(3)
	_key(KEY_ESCAPE, false)
	_check(paused, "TC-10: ESC menjeda gameplay")
	_check(game.get_node("UI/Pause").visible, "Panel pause terlihat")
	stopped = player.position
	_key(KEY_D, true)
	await _ticks(20)
	_key(KEY_D, false)
	_check(player.position.is_equal_approx(stopped), "Gerak fisika berhenti saat pause")
	game.get_node("UI/Pause/Center/Panel/Margin/Content/Resume").pressed.emit()
	await _ticks(3)
	_check(not paused and not game.get_node("UI/Pause").visible, "Lanjutkan menutup pause")
	_key(KEY_D, true)
	await _ticks(10)
	_key(KEY_D, false)
	_check(player.position.x > stopped.x + 12.0, "Gerak kembali aktif setelah resume")
	_key(KEY_ESCAPE, true)
	await _ticks(3)
	_key(KEY_ESCAPE, false)
	game.get_node("UI/Pause/Center/Panel/Margin/Content/Restart").pressed.emit()
	await _ticks(4)
	_check(not paused and current_scene.get_node("Player").position.is_equal_approx(spawn), "Ulangi memulihkan spawn dan melepas pause")
	_key(KEY_ESCAPE, true)
	await _ticks(3)
	_key(KEY_ESCAPE, false)
	_key(KEY_ESCAPE, true)
	await _ticks(3)
	_key(KEY_ESCAPE, false)
	_check(not paused, "ESC kedua melanjutkan gameplay")
	_key(KEY_ESCAPE, true)
	await _ticks(3)
	_key(KEY_ESCAPE, false)
	current_scene.get_node("UI/Pause/Center/Panel/Margin/Content/MainMenu").pressed.emit()
	await _ticks(4)
	_check(not paused and current_scene.scene_file_path == "res://scenes/main_menu.tscn", "TC-12: Menu Utama kembali ke menu dengan pause bersih")


func _finish() -> void:
	print("PHASE1_RESULT checks=", checks, " failures=", failures)
	quit(1 if failures > 0 else 0)
