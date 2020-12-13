extends Node2D

var previous_frame_health = Globals.player_health
var normal_style: StyleBoxTexture
var empty_style: StyleBoxTexture


func _ready():
	normal_style = StyleBoxTexture.new()
	normal_style.texture = load("res://assets/ui/hearts/heart.png")
	
	empty_style = StyleBoxTexture.new()
	empty_style.texture = load("res://assets/ui/hearts/heart_empty.png")
	
	refresh_health_bar()


func _process(delta):
	Globals.player_health = min(Globals.player_health, Globals.max_player_health)
		
	if previous_frame_health != Globals.player_health:
		refresh_health_bar()
	
	previous_frame_health = Globals.player_health
		
		
func refresh_health_bar():
	for heart in $HealthBar.get_children():
		var heart_number = int(heart.name.replace("Heart", ""))
		
		if heart_number <= Globals.player_health:
			heart.set("custom_styles/panel", normal_style)
		else:
			heart.set("custom_styles/panel", empty_style)
