extends StaticBody2D

signal target_moved(new_position: Vector2)

func _process(_delta):
	if Input.is_action_pressed("click"):
		position = get_global_mouse_position()
		target_moved.emit(position)
