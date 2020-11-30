extends Panel

var item_scene = preload("res://src/ui/Item.tscn")
var item


func _ready():
	if randi() % 2 > 0.5:
		item = item_scene.instance()
		item.texture = load("res://assets/items/sword.png")
		add_child(item)
