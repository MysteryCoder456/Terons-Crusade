extends Node

onready var item_data = LoadData("res://data/item_data.json")


func LoadData(json_path):
	var file = File.new()
	file.open(json_path, File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	
	return json_data.result
