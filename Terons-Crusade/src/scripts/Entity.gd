class_name Entity
extends KinematicBody2D

var velocity: Vector2
export var speed: Vector2

var health = 10
export var max_health: int


func _ready():
	$AnimatedSprite.playing = true
	$Inventory.visible = false
	
	
func _physics_process(delta):
	animate_character()
	velocity = get_movement_velocity()
	var temp_vel = move_and_slide(velocity, Vector2.UP)

	if is_on_floor() and velocity.y >= Globals.minimum_fall_damage_velocity:
		apply_fall_damage()
		
	velocity = temp_vel
		

func get_movement_velocity():
	# TODO: Add enemy AI
	pass
	
	
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
		

func apply_fall_damage():
	var fall_damage = int((velocity.y - Globals.minimum_fall_damage_velocity) / 100)
	health -= fall_damage
