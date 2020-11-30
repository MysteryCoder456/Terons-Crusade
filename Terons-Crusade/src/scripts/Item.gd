extends Node2D

export var item_texture: Texture


func _ready():
	$TextureRect.texture = item_texture
