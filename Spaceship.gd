extends RigidBody2D

const MAX_SPEED: int = 100
const DESIRED_LENGTH_AWAY: int = 30

@onready var navigation = $NavigationAgent2D

var target_position: Vector2

func _draw():
	var vec = get_global_transform_with_canvas().inverse() * (linear_velocity + global_position)
	draw_line(Vector2.ZERO, vec, Color.GREEN, 1)

func _process(_delta):
	queue_redraw()

func _physics_process(_delta):
	var next_position: Vector2 
	if !navigation.is_target_reached():
		next_position = navigation.get_next_path_position()
	else:
		# We still need to apply forces even after the spaceship reaches the target. We might be
		# overshooting, or the target might have moved for the spaceship to reach quickly.
		next_position = navigation.get_final_position()

	var distance = next_position - global_position
	var speed: int = min(MAX_SPEED, distance.length()) # for slow arrival behavior
	var desired_velocity: Vector2 = distance.normalized() * speed
	var force = desired_velocity - linear_velocity
	apply_central_force(force)
	
	var desired_angle := (target_position - global_position).angle()
	var torque := desired_angle - global_rotation
	# Figure out the best direction to turn. If the angle is greater than 2*PI, the it is better
	# to turn the other way.
	torque = fposmod(torque+PI, 2*PI) - PI
	apply_torque(torque)

func _on_target_target_moved(new_position: Vector2):
	target_position = new_position
	var to_target: Vector2 = new_position * get_global_transform() # convert to local coordinates 
	var desired_position_local := to_target.normalized() * (to_target.length() - DESIRED_LENGTH_AWAY)
	var desired_position_global := get_global_transform() * desired_position_local
	navigation.target_position = desired_position_global
