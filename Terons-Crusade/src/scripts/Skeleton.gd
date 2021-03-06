extends Entity

export var attack_range: float  # in blocks
export var attack_damage: float

onready var move_timer = $MoveTimer
onready var wait_timer = $WaitTimer
onready var attack_timer = $AttackTimer
onready var attack_return_timer = $AttackReturnTimer
var is_moving = false
var is_attacking = false
var able_to_attack = true
var direction = 0

var target = null

enum States {
	IDLE,
	ALERT
}

var state = States.IDLE


func animate_character():
	if velocity != Vector2.ZERO:
		if velocity.x > 0:
			animated_sprite.play("running")
			flip_horizontal(false)
		elif velocity.x < 0:
			animated_sprite.play("running")
			flip_horizontal(true)
			
		if velocity.y > 0:
			animated_sprite.play("falling")
		elif velocity.y < 0:
			animated_sprite.play("jumping")
	else:
		if is_attacking:
			animated_sprite.play("attack")
		else:
			animated_sprite.play("idle")


func get_movement_velocity():
	var movement_vector = velocity
	
	match state:
		States.IDLE:
			is_attacking = false
			if is_moving:
				movement_vector.x = direction * speed.x
		States.ALERT:
			var distance_to_target = global_position.distance_to(target.global_position)
			
			if distance_to_target < attack_range * 16:
				if able_to_attack and attack_timer.time_left == 0:
					attack_timer.start()
					is_attacking = true
					movement_vector.x = 0
			else:
				attack_timer.stop()
				is_attacking = false
				direction = Vector2(target.global_position - self.global_position).normalized().x
				movement_vector.x = direction * speed.x
			
	movement_vector.y += Globals.gravity * get_physics_process_delta_time()
			
	return movement_vector
	
	
func flip_horizontal(flip_h: bool):
	animated_sprite.flip_h = flip_h
	
	if flip_h:
		animated_sprite.offset.x = -9
	else:
		animated_sprite.offset.x = 9


func _on_MoveTimer_timeout():
	is_moving = false
	direction = 0
	wait_timer.start()


func _on_WaitTimer_timeout():
	is_moving = true
	direction = randi() % 3 - 1
	print(direction)
	move_timer.start()


func _on_AttackTimer_timeout():
	target.health -= attack_damage
	able_to_attack = false
	attack_return_timer.start()


func _on_AttackReturnTimer_timeout():
	able_to_attack = true


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player"):
		wait_timer.stop()
		move_timer.stop()
		target = body
		state = States.ALERT


func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("Player"):
		wait_timer.start()
		target = null
		state = States.IDLE


func _on_AnimatedSprite_animation_finished():
	if target:
		if target.is_dead:
			attack_timer.stop()
			target = null
			state = States.IDLE
