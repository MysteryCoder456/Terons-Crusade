extends Node

var gravity = 1000
var void_height = 2000
var air_resistance = 0.998

var minimum_fall_damage_blocks = 5  # 80 pixels
var minimum_fall_damage_velocity = sqrt(2 * gravity * (minimum_fall_damage_blocks * 16))

var Player = load("res://src/scripts/Player.gd")
const Item = preload("res://src/ui/Item.tscn")
const ItemDrop = preload("res://src/actors/ItemDrop.tscn")
const BloodParticles = preload("res://src/particles/BloodParticles.tscn")
const Arrow = preload("res://src/actors/Arrow.tscn")

var player_hotbar = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null
}

var player_inventory = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null,
	11: null,
	12: null,
	13: null,
	14: null,
	15: null,
	16: null,
	17: null,
	18: null,
	19: null,
	20: null,
	21: null,
	22: null,
	23: null,
	24: null,
	25: null,
	26: null,
	27: null,
	28: null,
	29: null,
	30: null,
	31: null,
	32: null
}
