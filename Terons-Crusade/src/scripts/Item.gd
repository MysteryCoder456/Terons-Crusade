extends Node2D

export var texture: Texture


func _ready():
	$TextureRect.texture = texture
