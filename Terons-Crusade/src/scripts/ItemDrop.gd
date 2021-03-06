extends KinematicBody2D

export var speed: float = 5000
export var item_name = "Sword"
export var item_quantity = 1
var velocity: Vector2
var is_picked_up = false
var player

onready var sprite = $Sprite


func init(name, quantity):
	item_name = name
	item_quantity = quantity


func _ready():
	var texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")
	sprite.texture = texture
	sprite.scale.x = 72 / texture.get_width()
	sprite.scale.y = 72 / texture.get_height()


func _physics_process(delta):
	if is_picked_up:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * speed, Globals.gravity * delta)
		
		if global_position.distance_to(player.global_position) < 7:
			var item = Globals.Item.instance()
			item.init(self.item_name, self.item_quantity)
			var pickup_success = player.get_node("Inventory").add_item(item)
			
			if pickup_success:
				queue_free()
			else:
				is_picked_up = false
	else:
		velocity.y += Globals.gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	

func pick_up(body):
	is_picked_up = true
	player = body
