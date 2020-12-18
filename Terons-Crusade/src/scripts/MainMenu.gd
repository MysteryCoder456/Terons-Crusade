extends Control


func _on_StartButton_pressed():
	print("Starting game...")
	get_tree().change_scene("res://src/scenes/world.tscn")


func _on_QuitButton_pressed():
	print("Exiting the game...")
	get_tree().quit()
