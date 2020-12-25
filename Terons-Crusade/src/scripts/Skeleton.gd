extends Entity

onready var move_timer = $MoveTimer
onready var wait_timer = $WaitTimer
var is_moving = false
var direction = 0

enum States {
	IDLE,
	ALERT
}

var state = States.IDLE


func _ready():
	randomize()


func get_movement_velocity():
	var movement_vector = velocity
	
	match state:
		States.IDLE:
			if is_moving:
				movement_vector.x = direction * speed.x
		States.ALERT:
			print("code")
			
	movement_vector.y += Globals.gravity * get_physics_process_delta_time()
			
	return movement_vector


func _on_MoveTimer_timeout():
	is_moving = false
	direction = 0
	wait_timer.start()


func _on_WaitTimer_timeout():
	is_moving = true
	direction = randi() % 3 - 1
	move_timer.start()
