extends RigidBody2D

const MAX_SPEED: int = 100
const DESIRED_LENGTH_AWAY: int = 25

@onready var navigation = $NavigationAgent2D

func _physics_process(delta):
	if !navigation.is_target_reached():
		var distance = navigation.get_next_path_position() - global_position
		var speed: int = min(MAX_SPEED, distance.length()) # for slow arrival behavior
		var desired_velocity: Vector2 = distance.normalized() * speed
		var force = desired_velocity - linear_velocity
		apply_central_force(force)
		
	# TODO: rotate to face the target

func _on_target_target_moved(new_position: Vector2):
	var to_target = (new_position - position)
	var desired_position_local = to_target.normalized() * (to_target.length() - DESIRED_LENGTH_AWAY)
	var desired_position_global = get_global_transform_with_canvas() * desired_position_local
	
	navigation.target_position = desired_position_global
