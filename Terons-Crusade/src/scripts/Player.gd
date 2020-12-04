extends KinematicBody2D

var velocity: Vector2
var inventory_open = false
var itemdrops_in_reach = []
export var speed: Vector2
export var reach_distance: float

var item_scene = preload("res://src/ui/Item.tscn")


func _ready():
	$AnimatedSprite.playing = true
	$Inventory.visible = false
	
	refresh_inventory()
	sync_inventory_and_hotbar()
	
	
func _input(event):
	if Input.is_action_just_pressed("open_inventory"):
		$Inventory.visible = !inventory_open
		inventory_open = $Inventory.visible
		$HotbarUI.visible = !$Inventory.visible
	
	if Input.is_action_just_pressed("pickup_item"):
		if len(itemdrops_in_reach) > 0:
			for itemdrop in itemdrops_in_reach:
				itemdrop.pick_up(self)


func _physics_process(delta):
	animate_character()
	velocity = get_movement_velocity()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func refresh_inventory():
	for hotbar_id in Globals.player_hotbar.keys():
		var item_info = Globals.player_hotbar[hotbar_id]
		if item_info:
			var item_object = item_scene.instance()
			item_object.init(item_info[0], item_info[1])
			get_node("Inventory/Hotbar/Slot" + String(hotbar_id + 1)).place_item(item_object)
			
	for inv_id in Globals.player_hotbar.keys():
		var item_info = Globals.player_inventory[inv_id]
		if item_info:
			var item_object = item_scene.instance()
			item_object.init(item_info[0], item_info[1])
			get_node("Inventory/MainInventory/Slot" + String(inv_id + 1)).place_item(item_object)
			
			
func sync_inventory_and_hotbar():
	# Clear Hotbar UI
	for child in $HotbarUI/HotbarGrid.get_children():
		$HotbarUI/HotbarGrid.remove_child(child)
		child.queue_free()
		
	for slot in $Inventory/Hotbar.get_children():
		$HotbarUI/HotbarGrid.add_child(slot)
	
	
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
