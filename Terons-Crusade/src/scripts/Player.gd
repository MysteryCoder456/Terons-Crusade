extends Entity

export var reach_distance: float # in pixels
export var hotbar_disappear_time = 2 # in seconds
export var attack_knockback: float

var inventory_open = false
var itemdrops_in_reach = []
var current_hotbar_selection = 0
var previous_hotbar_selection = 0
var hotbar_timer = hotbar_disappear_time

var death_animation_played = false  # Important to prevent death animation from repeating

var attackables = []

onready var camera = $Camera2D
onready var health_bar_overlay = $HealthBarOverlay
onready var inventory = $Inventory
onready var held_item = $HeldItem
onready var animation_player = $AnimationPlayer
onready var hotbar_overlay = $HotbarOverlay
onready var particles_position = $ParticlesPosition
onready var attack_area_collision_shape = $AttackArea/CollisionShape2D


func _ready():
	var camera_size = camera.get_viewport_rect().size * camera.zoom
	var health_bar_size = health_bar_overlay.get_node("HealthBar").rect_size * health_bar_overlay.scale
	var health_bar_adjust = Vector2(5, 3)
	var health_bar_pos = -camera_size / 2 + health_bar_size / 2 + health_bar_adjust
	
	health_bar_overlay.position = health_bar_pos
	
	inventory.visible = false
	
	refresh_inventory()
	
	$Inventory.visible = false
	
	
func _input(event):
	if not is_dead:
		var item_info = Globals.player_hotbar[current_hotbar_selection]
		
		# Open Inventory
		if Input.is_action_just_pressed("open_inventory"):
			inventory.visible = !inventory_open
			hotbar_timer = hotbar_disappear_time
			inventory_open = inventory.visible
		
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
			if item_info:
				var item_drop = Globals.ItemDrop.instance()
				
				item_drop.init(item_info[0], item_info[1])
				item_drop.global_position = self.global_position
				find_parent("world").add_child(item_drop)
				
				Globals.player_hotbar[current_hotbar_selection] = null
				sync_hotbar_overlay()
				refresh_inventory(true)
				
		if item_info:
			held_item.change_item(item_info[0])
		else:
			held_item.change_item(null)
			
		# Attacking
		if Input.is_action_just_pressed("break"):
			if item_info:
				var held_item_data = JsonData.item_data[item_info[0]]
				
				if held_item_data["category"] == "weapon":
					for attackable in attackables:
						attackable.health -= held_item_data["damage"]
						attackable.stun()
						
						if animated_sprite.flip_h:
							attackable.velocity.x -= attack_knockback
						else:
							attackable.velocity.x += attack_knockback


func _process(delta):
	held_item.visible = (velocity == Vector2.ZERO)
	
	if is_dead and not death_animation_played:
		animated_sprite.playing = false
		animation_player.play("jitter")
		
	if hotbar_timer < hotbar_disappear_time:
		hotbar_timer += delta
		if not hotbar_overlay.visible:
			hotbar_overlay.visible = true
	else:
		if hotbar_overlay.visible:
			hotbar_overlay.visible = false
	
	
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
	
	
func flip_horizontal(flip_h: bool):
	animated_sprite.flip_h = flip_h

	if flip_h:
		held_item.scale.x = -1
		held_item.position.x = -7
		attack_area_collision_shape.position.x = -22
	else:
		held_item.scale.x = 1
		held_item.position.x = 7
		attack_area_collision_shape.position.x = 22


func _on_ItemPickupDetector_body_entered(body):
	if body.collision_layer == 8:
		itemdrops_in_reach.append(body)


func _on_ItemPickupDetector_body_exited(body):
	if body in itemdrops_in_reach:
		itemdrops_in_reach.erase(body)


func _on_AttackArea_body_entered(body):
	if body.is_in_group("Attackable"):
		attackables.append(body)


func _on_AttackArea_body_exited(body):
	if body.is_in_group("Attackable"):
		attackables.erase(body)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jitter" and is_dead:
		death_animation_played = true
		
		# Create blood particles
		var particles = Globals.BloodParticles.instance()
		particles.global_position = particles_position.global_position
		find_parent("world").add_child(particles)
		particles.emitting = true
		animated_sprite.visible = false
		
		# Wait until particle has finished emitting
		var t = Timer.new()
		t.set_wait_time(particles.lifetime + 0.5)
		t.set_one_shot(true)
		add_child(t)
		t.start()
		yield(t, "timeout")
		
		particles.queue_free()
		t.queue_free()
