extends Node2D

var item_name
export var texture_scale: float = 1

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite


func _input(event):
	if Input.is_action_just_pressed("break"):
		if item_name:
			var item_info = JsonData.item_data[item_name]
			if item_info["category"] == "weapon" or item_info["category"] == "tool":
				animation_player.play("swing")
			

func _ready():
	sprite.texture = null


func change_item(new_item_name):
	item_name = new_item_name
	if item_name:
		var offset_multiplier = 2.88
		var texture = load("res://assets/items/" + item_name + "/" + item_name + ".png")
		sprite.texture = texture
		
		sprite.scale.x = 72 / texture.get_width() * texture_scale
		sprite.scale.y = 72 / texture.get_height() * texture_scale
		
		sprite.offset.x = texture.get_width() / offset_multiplier
		sprite.offset.y = texture.get_height() / -offset_multiplier
		
	else:
		sprite.texture = null
