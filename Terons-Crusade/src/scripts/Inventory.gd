extends Node2D

const Slot = preload("res://src/scripts/Slot.gd")
var held_item = null


func _ready():	
	for slot in $MainInventory.get_children():
		slot.connect("gui_input", self, "slot_gui_input", [slot])
		
	for slot in $Hotbar.get_children():
		slot.connect("gui_input", self, "slot_gui_input", [slot])

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
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
				

func _physics_process(delta):
	if held_item:
		held_item.global_position = get_global_mouse_position()
