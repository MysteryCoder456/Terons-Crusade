extends Node2D

var item_name
var item_quantity
var stack_size

func init(name, quantity):
	item_name = name
	item_quantity = quantity
	stack_size = int(JsonData.item_data[item_name]["stack_size"])


func _ready():
	var texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")
	$TextureRect.texture = texture
	$TextureRect.rect_scale.x = 72 / texture.get_width()
	$TextureRect.rect_scale.y = 72 / texture.get_height()
	$Label.text = String(item_quantity)
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		

func add_item_quantity(amount):
	item_quantity += amount
	$Label.text = String(item_quantity)
		

func remove_item_quantity(amount):
	item_quantity -= amount
	$Label.text = String(item_quantity)
