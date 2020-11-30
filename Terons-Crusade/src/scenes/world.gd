extends Node2D

onready var player = get_node("Player")
export var gravity: float
const DIRECTIONS = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]


func _input(event):
	if !player.inventory_open:
		var mouse_pos = get_global_mouse_position()
		var block_id = 2
		
		if mouse_pos.distance_to(player.global_position) <= player.reach_distance:
			if Input.is_action_just_pressed("use"):
				var block_position = $TileMap.world_to_map(mouse_pos)
				
				if $TileMap.get_cellv(block_position) == $TileMap.INVALID_CELL:
					if is_block_nearby(block_position):
						$TileMap.set_cellv(block_position, block_id)
				
			elif Input.is_action_just_pressed("break"):
				var block_position = $TileMap.world_to_map(mouse_pos)
				$TileMap.set_cellv(block_position, $TileMap.INVALID_CELL)
			
			
func is_block_nearby(block_pos) -> bool:
	for direction in DIRECTIONS:
		if $TileMap.get_cellv(block_pos + direction) != $TileMap.INVALID_CELL:
			return true
	return false
