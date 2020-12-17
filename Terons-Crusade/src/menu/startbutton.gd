extends Button


func _ready():
	pass 
	


func _on_startbutton_mouse_entered():
	print("Start button")
	pass
	



func _on_startbutton_pressed():
	print("Starts the game.")
	get_tree().change_scene("res://src/scenes/world.tscn")
