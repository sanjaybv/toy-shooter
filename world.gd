extends Node2D

func _draw():
	for x in range(0, 320, 20):
		draw_line(Vector2(x, 0), Vector2(x, 180), Color.LIGHT_GRAY, 1.0)
	for y in range(0, 180, 20):
		draw_line(Vector2(0, y), Vector2(320, y), Color.LIGHT_GRAY, 1.0)		
		


func _on_target_target_moved(new_position) -> void:
	for child in get_children():
		if child is Spaceship:
			child.set_target(new_position)
