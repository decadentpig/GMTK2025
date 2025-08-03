extends Node2D
class_name Game_Manager

const RESOURCE_SPAWN_CHANCE = 0.002
#const RESOURCE_SPAWN_CHANCE = 0.01 # FULL SPEEEED
const RESOURCE_SPAWN_TRACK_OFFSET = 120
const CARRIAGE_SIZE = 128
const CONTRACT_SPAWN_CHANCE = 0.0015
const FACTORY_SPAWN_CHANCE = 0.0005 # TEMPORARY!!
const CARRIAGE_SPAWN_CHANCE = 0.0002
const CARRIAGE_SPAWN_AFTER_CONTRACTS = 5

enum GAME_PHASE {PHASE1, PHASE2, PHASE3, PHASE4, PHASE5, PHASE6, PHASE7}
var current_phase: GAME_PHASE = GAME_PHASE.PHASE1

@onready var raw_resource_prefab = preload("res://Scenes/raw_resource_prefab.tscn")
@onready var contract_node_prefab = preload("res://Scenes/contract_node_prefab.tscn")
@onready var carriage_pickup_node_prefab = preload("res://Scenes/carriage_pickup_prefab.tscn")
@onready var factory_node_prefab = preload("res://Scenes/factory_node_prefab.tscn")
@onready var money_text = get_parent().get_node("Money_Text")

@export var ui_layer: CanvasLayer
@onready var floating_text_prefab = preload("res://Scenes/floating_text_prefab.tscn")
@export var checkpoint_node: Checkpoint_Node

@export var node_spawns: Node2D
@export var contract_spawns: Node2D
@export var factory_spawns: Node2D

func func_get_cord_for_side(side: Variant) -> int:
	if typeof(side) == TYPE_INT:
		return side
	elif typeof(side) == TYPE_ARRAY:
		return randi_range(side[0], side[1])
	else:
		print("ERROR", side)
		return 0

func get_item_spawn_location() -> Array:
	if node_spawns.get_child_count() == 0:
		print("Error! Could not find children in Node Spawns")
		return [0, 0]
	
	var random_index = randi() % node_spawns.get_child_count()
	var spawn = node_spawns.get_child(random_index)
	
	return [spawn.position.x, spawn.position.y]

#func get_item_spawn_location() -> Array:
	#var top_left_point = {"x": 300, "y": 320}
	#var bottom_left_point = {"x": 300, "y": 1030}
	#var bottom_right_point = {"x": 2100, "y": 1030}
	#var top_right_point = {"x": 2100, "y": 320}
	#
	#var sides = [
		## Outer left
		#{"x": top_left_point["x"] - RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_left_point["y"] + CARRIAGE_SIZE, bottom_left_point["y"] - CARRIAGE_SIZE]},
		## Inner left
		#{"x": top_left_point["x"] + RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_left_point["y"] + CARRIAGE_SIZE, bottom_left_point["y"] - CARRIAGE_SIZE]},
		## Outer bottom
		#{"x": [bottom_left_point["x"] + CARRIAGE_SIZE, bottom_right_point["x"] - CARRIAGE_SIZE], "y": bottom_left_point["y"] + RESOURCE_SPAWN_TRACK_OFFSET},
		## Inner bottom
		#{"x": [bottom_left_point["x"] + CARRIAGE_SIZE, bottom_right_point["x"] - CARRIAGE_SIZE], "y": bottom_left_point["y"] - RESOURCE_SPAWN_TRACK_OFFSET},
		## Outer right
		#{"x": bottom_right_point["x"] + RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_right_point["y"] + CARRIAGE_SIZE, bottom_right_point["y"] - CARRIAGE_SIZE]},
		## Inner right
		#{"x": bottom_right_point["x"] - RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_right_point["y"] + CARRIAGE_SIZE, bottom_right_point["y"] - CARRIAGE_SIZE]},
		## Outer top
		#{"x": [top_left_point["x"] + CARRIAGE_SIZE, top_right_point["x"] - CARRIAGE_SIZE], "y": top_right_point["y"] - RESOURCE_SPAWN_TRACK_OFFSET},
		## Inner top
		#{"x": [top_left_point["x"] + CARRIAGE_SIZE, top_right_point["x"] - CARRIAGE_SIZE], "y": top_right_point["y"] + RESOURCE_SPAWN_TRACK_OFFSET},
	#]
	#
		#
	## Pick side that resource spawns on
	#var random_side_index = randi() % sides.size()
	#var chosen_side = sides[random_side_index]
	#
	## Choose spawn location on side
	#var chosen_x = func_get_cord_for_side(chosen_side["x"])
	#var chosen_y = func_get_cord_for_side(chosen_side["y"])
	#
	#return [chosen_x, chosen_y]

func get_random_factory() -> GlobalVariables.FACTORY_TYPE:
	var factories = [GlobalVariables.FACTORY_TYPE.PLANK, GlobalVariables.FACTORY_TYPE.INGOT, GlobalVariables.FACTORY_TYPE.CRATE, GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER]
	var factory_type_index = randi() % factories.size()
	return factories[factory_type_index]

func spawn_factory() -> void:
	var spawn_location = get_item_spawn_location()
	var chosen_x = spawn_location[0]
	var chosen_y = spawn_location[1]
	
	# Choose factory type
	var factory_type = get_random_factory()
	
	# Spawn on grid
	var factory = factory_node_prefab.instantiate()
	add_child(factory)
	factory.set_factory_type(factory_type)
	factory.position = Vector2(chosen_x, chosen_y)

func get_random_resource() -> GlobalVariables.RESOURCE_TYPE:
	var resources = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL]
	var resource_type_index = randi() % resources.size()
	return resources[resource_type_index]

func spawn_resource(resource_type: GlobalVariables.RESOURCE_TYPE, pos: Vector2) -> void:
	var chosen_x = pos.x
	var chosen_y = pos.y
	
	# Spawn on grid 
	var resource = raw_resource_prefab.instantiate()
	add_child(resource)
	resource.set_resource_type(resource_type)
	resource.position = Vector2(chosen_x, chosen_y)
	
func spawn_contract(resource_type: GlobalVariables.RESOURCE_TYPE, pos: Vector2) -> void:
	var chosen_x = pos.x
	var chosen_y = pos.y
	
	# Spawn on grid 
	var contract = contract_node_prefab.instantiate()
	add_child(contract)
	contract.set_contract_type(resource_type)
	contract.initialise(self)
	contract.position = Vector2(chosen_x, chosen_y)
	
func spawn_carriage() -> void:
	var spawn_location = get_item_spawn_location()
	var chosen_x = spawn_location[0]
	var chosen_y = spawn_location[1]
	var carriage_pickup_node = carriage_pickup_node_prefab.instantiate()
	carriage_pickup_node.cost = Stats.num_carriages * 10 
	add_child(carriage_pickup_node)
	carriage_pickup_node.position = Vector2(chosen_x, chosen_y)
	Stats.available_carriages += 1

func resolve_checkpoint():
	var checkpoint_tax = 1
	Stats.money -= checkpoint_tax
	
	
	var y = checkpoint_node.position.y - 128
	var x = checkpoint_node.position.x - 64
	var str = '- $' + str(checkpoint_tax)
	create_floating_text(Vector2(x,y), str, Color.RED, 120)
	
	if Stats.money >= 1:
		print("Paid the toll!")
	else:
		print("Lost the game!")
		Stats.apply_defaults()
		get_tree().change_scene_to_file("res://main_menu.tscn")

func create_floating_text(pos: Vector2, text: String, color: Color, frames: int):
	var floating_text = floating_text_prefab.instantiate()
	ui_layer.add_child(floating_text)
	floating_text.setup_floating_text(pos, text, color, frames)

func process_finite_state_machine():
	# PHASE 1
	# Resource Spawns: Wood
	# Contracts: Wood
	# Factories: (none)
	# Rent Increase Per Lap: 2
	
	# PHASE 1 CONSTANTS
	const PHASE1_MAX_CONTRACTS = 3
	const PHASE1_MAX_NUM_WOOD = 2
	const PHASE1_WOOD_RAND_CHANCE = 0.002
	const PHASE1_CONTRACT_RAND_CHANCE = 0.002
	
	if current_phase == GAME_PHASE.PHASE1:
		# 1. Check how many wood nodes exist to be picked up, and their locations
		var num_wood = 0
		var num_contracts = 0
		var used_locations = []
		
		for child in get_children():
			if (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.WOOD
			):
				num_wood += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE1_MAX_NUM_WOOD and randf() < PHASE1_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE1_MAX_CONTRACTS and randf() < PHASE1_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_contract(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
	
	
	# PHASE 2
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal
	# Factories (none)
	# Rent Increase Per Lap: 5
	if current_phase == GAME_PHASE.PHASE2:
		pass

	# PHASE 3
	# Resource Spawns: Wood, Metal, Carriages
	# Contracts: Wood, Metal
	# Factories: (none)
	# Rent Increase Per Lap: 5
	if current_phase == GAME_PHASE.PHASE3:
		pass

	# PHASE 4
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks
	# Factories: Planks
	# Rent Increase Per Lap: 10
	if current_phase == GAME_PHASE.PHASE4:
		pass
	
	# PHASE 5
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks, Ingots
	# Factories: Planks, Ingots
	# Rent Increase Per Lap: 20
	if current_phase == GAME_PHASE.PHASE5:
		pass
	
	# PHASE 6
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks, Ingots, Crates
	# Factories: Planks, Ingots, Crates
	# Rent Increase Per Lap: 30
	if current_phase == GAME_PHASE.PHASE6:
		pass
	
	# PHASE 7
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks, Ingots, Crates, Shipping Containers
	# Factories: Planks, Ingots, Crates, Shipping Containers
	# Rent Increase Per Lap: 50
	if current_phase == GAME_PHASE.PHASE7:
		pass
	
	pass

func _process(delta: float) -> void:
	# TODO: Change state / phase based on ??
	process_finite_state_machine()

	
	#if (
		#randf() < CARRIAGE_SPAWN_CHANCE
		#and Stats.contracts_complete > CARRIAGE_SPAWN_AFTER_CONTRACTS
		#and Stats.available_carriages < GlobalVariables.MAX_CARRIAGE_PICKUPS
	#):
		#spawn_carriage()
#
	money_text.text = str(Stats.money)

func _ready() -> void:
	MusicPlayer.play_background_music()
