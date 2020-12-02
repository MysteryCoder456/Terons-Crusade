extends Panel

var item = null


func pick_item():
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item = null
	
	
func place_item(new_item):
	item = new_item
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
