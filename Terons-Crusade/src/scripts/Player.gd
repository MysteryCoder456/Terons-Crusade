extends KinematicBody2D

var gravity: float
var velocity: Vector2
export var speed: Vector2


func _ready():
	gravity = get_tree().get_root().get_node("world").gravity


func _physics_process(delta):
	velocity = get_movement_velocity()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func get_movement_velocity():
	var movement_vector = velocity
	movement_vector.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * speed.x

#	Apply gravity
	movement_vector.y += gravity * get_physics_process_delta_time()
	
	return movement_vector
