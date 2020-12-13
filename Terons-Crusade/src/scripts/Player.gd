extends KinematicBody2D

var velocity: Vector2
export var speed: Vector2
export var reach_distance: float
export var hotbar_disappear_time = 2 # in seconds

var inventory_open = false
var itemdrops_in_reach = []
var current_hotbar_selection = 0
var previous_hotbar_selection = 0
var hotbar_timer = hotbar_disappear_time


func _ready():
	$AnimatedSprite.playing = true
	$Inventory.visible = false
	
	refresh_inventory()
	
	
func _input(event):
	# Open Inventory
	if Input.is_action_just_pressed("open_inventory"):
		$Inventory.visible = !inventory_open
		hotbar_timer = hotbar_disappear_time
		inventory_open = $Inventory.visible
	
	# Pickup Item Drops
	if Input.is_action_just_pressed("pickup_item"):
		if len(itemdrops_in_reach) > 0:
			for itemdrop in itemdrops_in_reach:
				itemdrop.pick_up(self)
				
	previous_hotbar_selection = current_hotbar_selection
	
	if not inventory_open:
		# Hotbar Item Selection
		if Input.is_action_just_pressed("hotbar_up"):
			current_hotbar_selection -= 1
		elif Input.is_action_just_pressed("hotbar_down"):
			current_hotbar_selection += 1
		
		if current_hotbar_selection > 8:
			current_hotbar_selection = 0
		elif current_hotbar_selection < 0:
			current_hotbar_selection = 8
		
		if Input.is_key_pressed(KEY_1):
			current_hotbar_selection = 0
		elif Input.is_key_pressed(KEY_2):
			current_hotbar_selection = 1
		elif Input.is_key_pressed(KEY_3):
			current_hotbar_selection = 2
		elif Input.is_key_pressed(KEY_4):
			current_hotbar_selection = 3
		elif Input.is_key_pressed(KEY_5):
			current_hotbar_selection = 4
		elif Input.is_key_pressed(KEY_6):
			current_hotbar_selection = 5
		elif Input.is_key_pressed(KEY_7):
			current_hotbar_selection = 6
		elif Input.is_key_pressed(KEY_8):
			current_hotbar_selection = 7
		elif Input.is_key_pressed(KEY_9):
			current_hotbar_selection = 8
			
		if current_hotbar_selection != previous_hotbar_selection:
			get_node("HotbarOverlay/Hotbar/Slot" + String(current_hotbar_selection + 1)).select()
			get_node("HotbarOverlay/Hotbar/Slot" + String(previous_hotbar_selection + 1)).deselect()
			hotbar_timer = 0
		
	# Dropping items from hotbar
	if Input.is_action_just_pressed("drop_item"):
		var item_info = Globals.player_hotbar[current_hotbar_selection]
		if item_info:
			var item_drop = Globals.ItemDrop.instance()
			
			item_drop.init(item_info[0], item_info[1])
			item_drop.global_position = self.global_position
			find_parent("world").add_child(item_drop)
			
			Globals.player_hotbar[current_hotbar_selection] = null
			sync_hotbar_overlay()
			refresh_inventory(true)


func _physics_process(delta):
	if hotbar_timer < hotbar_disappear_time:
		hotbar_timer += delta
		if not $HotbarOverlay.visible:
			$HotbarOverlay.visible = true
	else:
		if $HotbarOverlay.visible:
			$HotbarOverlay.visible = false
	
	animate_character()
	velocity = get_movement_velocity()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func sync_hotbar_overlay():
	for i in range(len(Globals.player_hotbar)):
		var item_info = Globals.player_hotbar[i]
		var slot = get_node("HotbarOverlay/Hotbar/Slot" + String(i + 1))
		
		if slot.item:
			slot.item.queue_free()
		slot.pick_item()
		
		if item_info:
			var new_item = Globals.Item.instance()
			new_item.init(item_info[0], item_info[1])
			slot.place_item(new_item)
	
	
func refresh_inventory(only_hotbar = false):
	for hotbar_id in Globals.player_hotbar.keys():
		var item_info = Globals.player_hotbar[hotbar_id]
		var slot = get_node("Inventory/Hotbar/Slot" + String(hotbar_id + 1))
		
		if slot.item:
			slot.item.queue_free()
		slot.pick_item()
		
		if item_info:
			var item_object = Globals.Item.instance()
			item_object.init(item_info[0], item_info[1])
			slot.place_item(item_object)
	
	if not only_hotbar:
		for inv_id in Globals.player_hotbar.keys():
			var item_info = Globals.player_inventory[inv_id]
			var slot = get_node("Inventory/MainInventory/Slot" + String(inv_id + 1))
		
			if slot.item:
				slot.item.queue_free()
			slot.pick_item()
			
			if item_info:
				var item_object = Globals.Item.instance()
				item_object.init(item_info[0], item_info[1])
				slot.place_item(item_object)
	
	
func get_movement_velocity():
	var movement_vector = velocity
	
	if !inventory_open:
		movement_vector.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * speed.x

	if Input.is_action_just_pressed("jump") and is_on_floor() and !inventory_open:
		movement_vector.y = -speed.y
	else:
		movement_vector.y += Globals.gravity * get_physics_process_delta_time()
	
	return movement_vector
	
	
func animate_character():	
	if velocity != Vector2.ZERO:
		if velocity.x > 0:
			$AnimatedSprite.play("running")
			$AnimatedSprite.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite.play("running")
			$AnimatedSprite.flip_h = true
			
		if velocity.y > 0:
			$AnimatedSprite.play("falling")
		elif velocity.y < 0:
			$AnimatedSprite.play("jumping")
	else:
		$AnimatedSprite.play("idle")


func _on_ItemPickupDetector_body_entered(body):
	if body.collision_layer == 8:
		itemdrops_in_reach.append(body)


func _on_ItemPickupDetector_body_exited(body):
	if body in itemdrops_in_reach:
		itemdrops_in_reach.erase(body)
