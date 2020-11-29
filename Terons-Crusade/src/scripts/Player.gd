extends KinematicBody2D

var gravity: float
var velocity: Vector2
export var speed: Vector2
export var reach_distance: float


func _ready():
	$AnimatedSprite.playing = true
	gravity = get_tree().get_root().get_node("world").gravity


func _physics_process(delta):
	animate_character()
	velocity = get_movement_velocity()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func get_movement_velocity():
	var movement_vector = velocity
	movement_vector.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * speed.x

	if Input.is_action_just_pressed("jump") and is_on_floor():
		movement_vector.y = -speed.y
	else:
		movement_vector.y += gravity * get_physics_process_delta_time()
	
	return movement_vector
	
	
func animate_character():	
	if velocity != Vector2.ZERO:
		if velocity.x > 0:
			$AnimatedSprite.play("running")
			$AnimatedSprite.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite.play("running")
			$AnimatedSprite.flip_h = true
			
		if velocity.y > 0:
			$AnimatedSprite.play("falling")
		elif velocity.y < 0:
			$AnimatedSprite.play("jumping")
	else:
		$AnimatedSprite.play("idle")
