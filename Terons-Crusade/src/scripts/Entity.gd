class_name Entity
extends KinematicBody2D

var velocity: Vector2
export var speed: Vector2

var health = 10
export var max_health: int
var is_dead = false


func _ready():
	$AnimatedSprite.playing = true
	$Inventory.visible = false
	
	
func _physics_process(delta):	
	if health <= 0:
		is_dead = true
	
	if not is_dead:
		animate_character()
		
		velocity = get_movement_velocity()
		var temp_vel = move_and_slide(velocity, Vector2.UP)
		
		# Fall damage
		if is_on_floor() and velocity.y >= Globals.minimum_fall_damage_velocity:
			apply_fall_damage()
		
		# Void damage
		if global_position.y >= Globals.void_height:
			health -= delta
			
		velocity = temp_vel


func get_movement_velocity():
	# TODO: Add enemy AI
	pass
	
	
func animate_character():
	if velocity != Vector2.ZERO:
		if velocity.x > 0:
			$AnimatedSprite.play("running")
			flip_horizontal(false)
		elif velocity.x < 0:
			$AnimatedSprite.play("running")
			flip_horizontal(true)
			
		if velocity.y > 0:
			$AnimatedSprite.play("falling")
		elif velocity.y < 0:
			$AnimatedSprite.play("jumping")
	else:
		$AnimatedSprite.play("idle")
		

func apply_fall_damage():
	var fall_damage = int((velocity.y - Globals.minimum_fall_damage_velocity) / 100)
	health -= fall_damage
	

func flip_horizontal(flip_h: bool):
	$AnimatedSprite.flip_h = flip_h
