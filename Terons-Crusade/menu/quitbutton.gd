extends Button

func _ready():
	pass
	
	
func _on_quitbutton_mouse_entered():
	print("Quit button")
	
	

func _on_quitbutton_pressed():
	print("Exiting the game.")
	get_tree().quit()


