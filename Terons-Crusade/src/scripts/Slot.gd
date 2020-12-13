extends Panel

var item = null
export var is_overlay: bool

var selected_style: StyleBoxTexture
var deselected_style: StyleBoxTexture

func _ready():
	selected_style = StyleBoxTexture.new()
	selected_style.texture = load("res://assets/ui/inventory_slots/inventory_slot_selected.png")
	
	deselected_style = StyleBoxTexture.new()
	deselected_style.texture = load("res://assets/ui/inventory_slots/inventory_slot.png")


func pick_item():
	remove_child(item)
	if not is_overlay:
		var inventory_node = find_parent("Inventory")
		inventory_node.add_child(item)
	item = null
	
	
func place_item(new_item):
	item = new_item
	if not is_overlay:
		var inventory_node = find_parent("Inventory")
		inventory_node.remove_child(item)
	add_child(item)
	
	
func select():
	if is_overlay:
		set("custom_styles/panel", selected_style)
		
func deselect():
	if is_overlay:
		set("custom_styles/panel", deselected_style)
