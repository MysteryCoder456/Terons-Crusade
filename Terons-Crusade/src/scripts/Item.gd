extends Node2D

var item_name
var item_quantity
var stack_size

onready var texture_rect = $TextureRect
onready var label = $Label


func init(name, quantity):
	item_name = name
	item_quantity = quantity
	stack_size = int(JsonData.item_data[item_name]["stack_size"])


func _ready():
	var texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")
	texture_rect.texture = texture
	texture_rect.rect_scale.x = 72 / texture.get_width()
	texture_rect.rect_scale.y = 72 / texture.get_height()
	label.text = String(item_quantity)
	
	if stack_size == 1:
		label.visible = false
	else:
		label.visible = true
		

func add_item_quantity(amount):
	item_quantity += amount
	label.text = String(item_quantity)
		

func remove_item_quantity(amount):
	item_quantity -= amount
	label.text = String(item_quantity)
