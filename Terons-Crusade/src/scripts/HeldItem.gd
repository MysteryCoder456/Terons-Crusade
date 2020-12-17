extends Node2D

var item_name
export var texture_scale: float = 1

func _input(event):
	if Input.is_action_just_pressed("break"):
		if item_name:
			var item_info = JsonData.item_data[item_name] 
			if item_info["category"] == "weapon" or item_info["category"] == "tool":
				$AnimationPlayer.play("swing")
			

func _ready():
	$Sprite.texture = null


func change_item(new_item_name):
	item_name = new_item_name
	if item_name:
		var texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")
		$Sprite.texture = texture
		$Sprite.scale.x = 72 / texture.get_width() * texture_scale
		$Sprite.scale.y = 72 / texture.get_height() * texture_scale
	else:
		$Sprite.texture = null
