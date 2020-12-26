extends Node2D

onready var player = get_node("Player")
const DIRECTIONS = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]


func _ready():
	print("TileSet Tile IDs: ", $TileMap.tile_set.get_tiles_ids())
	randomize()
	

func _input(event):
	if !player.inventory_open:
		var player_held_item = Globals.player_hotbar[player.current_hotbar_selection]
		var mouse_pos = get_global_mouse_position()
				
		if player_held_item:
			var item_info = JsonData.item_data[player_held_item[0]]
					
			if item_info["category"] == "block":
				if Input.is_action_just_pressed("use"):
					var block_id = item_info["block_id"]
					
					if mouse_pos.distance_to(player.global_position) <= player.reach_distance:
						var block_position = $TileMap.world_to_map(mouse_pos)
						
						if $TileMap.get_cellv(block_position) == $TileMap.INVALID_CELL:
							if is_block_nearby(block_position):
								$TileMap.set_cellv(block_position, block_id)
								
								# Remove item from inventory
								if Globals.player_hotbar[player.current_hotbar_selection][1] > 1:
									Globals.player_hotbar[player.current_hotbar_selection][1] -= 1
								else:
									Globals.player_hotbar[player.current_hotbar_selection] = null
									
								player.refresh_inventory(true)
								player.sync_hotbar_overlay()
								
			elif item_info["category"] == "tool":
				if Input.is_action_just_pressed("break"):
					var block_position = $TileMap.world_to_map(mouse_pos)
					var cell_id = $TileMap.get_cellv(block_position)
					
					if cell_id != $TileMap.INVALID_CELL:
						var tool_type_required = JsonData.item_data[$TileMap.tile_set.tile_get_name(cell_id)]["tool_type_required"]
						
						if tool_type_required == item_info["tool_type"]:
							if mouse_pos.distance_to(player.global_position) <= player.reach_distance:
								$TileMap.set_cellv(block_position, $TileMap.INVALID_CELL)
			
			
func is_block_nearby(block_pos) -> bool:
	for direction in DIRECTIONS:
		if $TileMap.get_cellv(block_pos + direction) != $TileMap.INVALID_CELL:
			return true
	return false
