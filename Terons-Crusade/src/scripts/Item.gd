extends Node2D

var item_name
var item_quantity = 1
var stack_size = 64


func _ready():
	$TextureRect.texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")
	$Label.text = String(item_quantity)
	stack_size = int(JsonData.item_data[item_name]["stack_size"])
	
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
