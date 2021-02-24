extends KinematicBody2D

var hit = false
var direction: float
var velocity: Vector2
const mass = 0.0035
const speed = 7

onready var despawn_timer = $DespawnTimer


func init(position: Vector2, dir: float):
	global_position = position
	velocity = Vector2(cos(dir), sin(dir)) * speed


func _physics_process(delta):
	if not hit:
		velocity.x *= Globals.air_resistance
		velocity.y += Globals.gravity * delta * mass
		global_rotation = velocity.angle_to_point(Vector2.ZERO)

		var collision = move_and_collide(velocity)
		if collision:
			hit = true
			velocity = Vector2.ZERO
			despawn_timer.start()


func _on_DespawnTimer_timeout():
	self.queue_free()
