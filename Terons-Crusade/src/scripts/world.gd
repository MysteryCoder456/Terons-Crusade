extends Node2D

const DIRECTIONS = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
onready var player = get_node("Player")
onready var tile_map = $TileMap


func _ready():
	print("TileSet Tile IDs: ", tile_map.tile_set.get_tiles_ids())
	

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
						var block_position = tile_map.world_to_map(mouse_pos)
						
						if tile_map.get_cellv(block_position) == tile_map.INVALID_CELL:
							if is_block_nearby(block_position):
								tile_map.set_cellv(block_position, block_id)
								
								# Remove item from inventory
								if Globals.player_hotbar[player.current_hotbar_selection][1] > 1:
									Globals.player_hotbar[player.current_hotbar_selection][1] -= 1
								else:
									Globals.player_hotbar[player.current_hotbar_selection] = null
									
								player.refresh_inventory(true)
								player.sync_hotbar_overlay()
								
			elif item_info["category"] == "tool":
				if Input.is_action_just_pressed("break"):
					var block_position = tile_map.world_to_map(mouse_pos)
					var cell_id = tile_map.get_cellv(block_position)
					
					if cell_id != tile_map.INVALID_CELL:
						var tool_type_required = JsonData.item_data[tile_map.tile_set.tile_get_name(cell_id)]["tool_type_required"]
						
						if tool_type_required == item_info["tool_type"]:
							if mouse_pos.distance_to(player.global_position) <= player.reach_distance:
								tile_map.set_cellv(block_position, tile_map.INVALID_CELL)
			
			
func is_block_nearby(block_pos) -> bool:
	for direction in DIRECTIONS:
		if tile_map.get_cellv(block_pos + direction) != tile_map.INVALID_CELL:
			return true
	return false
