extends Node2D

const Slot = preload("res://src/scripts/Slot.gd")
const Item = preload("res://src/scripts/Item.gd")
onready var player = find_parent("Player")
var held_item = null


func _ready():	
	for slot in $MainInventory.get_children():
		slot.connect("gui_input", self, "slot_gui_input", [slot, false])
		
	for slot in $Hotbar.get_children():
		slot.connect("gui_input", self, "slot_gui_input", [slot, true])

func slot_gui_input(event: InputEvent, slot: Slot, in_hotbar):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var slot_id = int(slot.name.replace("Slot", ""))
			
			if held_item:
				if !slot.item:
					held_item.position = Vector2(7.2, 7.2)
					slot.place_item(held_item)
					held_item = null
				else:
					if slot.item.item_name == held_item.item_name:
						var addable = slot.item.stack_size - slot.item.item_quantity
						if addable >= held_item.item_quantity:
							slot.item.add_item_quantity(held_item.item_quantity)
							held_item.queue_free()
							held_item = null
						else:
							slot.item.add_item_quantity(addable)
							held_item.remove_item_quantity(addable)
					else:
						var temp_item = slot.item
						slot.pick_item()
						held_item.position = Vector2(7.2, 7.2)
						slot.place_item(held_item)
						held_item = temp_item
						held_item.global_position = get_global_mouse_position()
			else:
				if slot.item:
					held_item = slot.item
					held_item.global_position = get_global_mouse_position()
					slot.pick_item()
					if in_hotbar:
						Globals.player_hotbar[slot_id - 1] = null
					else:
						Globals.player_inventory[slot_id - 1] = null
					
					
			# Update inventory variables
			if slot.item:
				var item_info = [slot.item.item_name, slot.item.item_quantity]
				if in_hotbar:
					Globals.player_hotbar[slot_id - 1] = item_info
				else:
					Globals.player_inventory[slot_id - 1] = item_info
					
			if in_hotbar:
				player.sync_hotbar_overlay()
				

func add_item(item: Item) -> bool:
	var free_slot = null
	var slot_found = false
	var slot_found_in_hotbar = false
	
	# Find existing stack in hotbar
	for slot in $Hotbar.get_children():
		if slot.item:
			if slot.item.item_name == item.item_name:
				if slot.item.item_quantity + item.item_quantity <= item.stack_size:
					slot.item.add_item_quantity(item.item_quantity)
					free_slot = slot
					slot_found = true
					slot_found_in_hotbar = true
					break
			
#	# Find existing stack in inventory
	if not slot_found:
		for slot in $MainInventory.get_children():
			if slot.item:
				if slot.item.item_name == item.item_name:
					if slot.item.item_quantity + item.item_quantity <= item.stack_size:
						slot.item.add_item_quantity(item.item_quantity)
						free_slot = slot
						slot_found = true
						break
#
#	# Find free slot in hotbar
	if not slot_found:
		for slot in $Hotbar.get_children():
			if not slot.item:
				slot.place_item(item)
				free_slot = slot
				slot_found = true
				slot_found_in_hotbar = true
				break
#
#	# Find free slot in inventory
	if not slot_found:
		for slot in $MainInventory.get_children():
			if not slot.item:
				slot.place_item(item)
				free_slot = slot
				slot_found = true
				break
				
	if slot_found:
		var slot_id = int(free_slot.name.replace("Slot", ""))
		var item_info = [free_slot.item.item_name, free_slot.item.item_quantity]
		if slot_found_in_hotbar:
			Globals.player_hotbar[slot_id - 1] = item_info
		else:
			Globals.player_inventory[slot_id - 1] = item_info
			
	if slot_found_in_hotbar:
		player.sync_hotbar_overlay()
	
	return slot_found


func _physics_process(delta):
	if held_item:
		held_item.global_position = get_global_mouse_position()
