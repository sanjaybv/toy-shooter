extends RigidBody2D

const MAX_SPEED: int = 100

@onready var navigation = $NavigationAgent2D

func _physics_process(delta):
	if !navigation.is_target_reached():
		var distance = navigation.get_next_path_position() - global_position
		var speed: int = min(MAX_SPEED, distance.length())
		var desired_velocity: Vector2 = distance.normalized() * speed
		var force = desired_velocity - linear_velocity
		apply_central_force(force)

func _on_target_target_moved(new_position: Vector2):
	navigation.target_position = new_position
