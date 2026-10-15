extends CharacterBody2D

@export var speed: float = 100.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		# OS tidak selalu mengirim key-up ketika pemain berpindah window.
		for action_name in ["move_left", "move_right", "move_up", "move_down"]:
			Input.action_release(action_name)
