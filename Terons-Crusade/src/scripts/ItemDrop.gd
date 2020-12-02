extends KinematicBody2D

var item_name = "Sword"
var velocity: Vector2


func _ready():
	$Sprite.texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")


func _physics_process(delta):
	velocity.y += Globals.gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
