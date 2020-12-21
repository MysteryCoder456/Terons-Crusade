extends Node2D

var previous_frame_health: int
var normal_style: StyleBoxTexture
var empty_style: StyleBoxTexture

onready var player = find_parent("Player")
onready var health_bar = $HealthBar


func _ready():
	normal_style = StyleBoxTexture.new()
	normal_style.texture = load("res://assets/ui/hearts/heart.png")
	
	empty_style = StyleBoxTexture.new()
	empty_style.texture = load("res://assets/ui/hearts/heart_empty.png")
	
	refresh_health_bar()


func _process(delta):
	if previous_frame_health != player.health:
		player.health = min(player.health, player.max_health)
		refresh_health_bar()
	
	previous_frame_health = player.health
		
		
func refresh_health_bar():
	for heart in health_bar.get_children():
		var heart_number = int(heart.name.replace("Heart", ""))
		
		if heart_number <= player.health:
			heart.set("custom_styles/panel", normal_style)
		else:
			heart.set("custom_styles/panel", empty_style)
