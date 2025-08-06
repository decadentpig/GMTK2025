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
var num_loops_since_phase_change = -1

var checkpoint_tax = 1
const PHASE1_TAX_INCREASE = 1
const PHASE2_TAX_INCREASE = 1
const PHASE3_TAX_INCREASE = 1
const PHASE4_TAX_INCREASE = 1
const PHASE5_TAX_INCREASE = 1
const PHASE6_TAX_INCREASE = 1
const PHASE7_TAX_INCREASE = 1

# PHASE 1 CONSTANTS
const PHASE1_MAX_CONTRACTS = 4
const PHASE1_MAX_NUM_WOOD = 4
const PHASE1_WOOD_RAND_CHANCE = 0.003
const PHASE1_CONTRACT_RAND_CHANCE = 0.003

# PHASE 2 CONSTANTS
const PHASE2_MAX_CONTRACTS = 8
const PHASE2_MAX_NUM_WOOD = 4
const PHASE2_MAX_NUM_METAL = 4
const PHASE2_WOOD_RAND_CHANCE = 0.004
const PHASE2_METAL_RAND_CHANCE = 0.004
const PHASE2_CONTRACT_RAND_CHANCE = 0.004

# PHASE 3 CONSTANTS
const PHASE3_MAX_CONTRACTS = 8
const PHASE3_MAX_NUM_WOOD = 6
const PHASE3_MAX_NUM_METAL = 6
const PHASE3_MAX_NUM_CARRIAGES = 1
const PHASE3_WOOD_RAND_CHANCE = 0.004
const PHASE3_METAL_RAND_CHANCE = 0.004
const PHASE3_CONTRACT_RAND_CHANCE = 0.004
const PHASE3_CARRIAGE_RAND_CHANCE = 0.0004

# PHASE 4 CONSTANTS
const PHASE4_MAX_CONTRACTS = 10
const PHASE4_MAX_NUM_WOOD = 7
const PHASE4_MAX_NUM_METAL = 7
const PHASE4_MAX_NUM_CARRIAGES = 1
const PHASE4_MAX_PLANK_FACTORIES = 1
const PHASE4_WOOD_RAND_CHANCE = 0.004
const PHASE4_METAL_RAND_CHANCE = 0.004
const PHASE4_CONTRACT_RAND_CHANCE = 0.004
const PHASE4_CARRIAGE_RAND_CHANCE = 0.0004
const PHASE4_PLANK_FACTORY_RAND_CHANCE = 0.004

# PHASE 5 CONSTANTS
const PHASE5_MAX_CONTRACTS = 10
const PHASE5_MAX_NUM_WOOD = 8
const PHASE5_MAX_NUM_METAL = 8
const PHASE5_MAX_NUM_CARRIAGES = 1
const PHASE5_MAX_PLANK_FACTORIES = 1
const PHASE5_MAX_INGOT_FACTORIES = 1
const PHASE5_WOOD_RAND_CHANCE = 0.004
const PHASE5_METAL_RAND_CHANCE = 0.004
const PHASE5_CONTRACT_RAND_CHANCE = 0.004
const PHASE5_CARRIAGE_RAND_CHANCE = 0.0004
const PHASE5_PLANK_FACTORY_RAND_CHANCE = 0.004
const PHASE5_INGOT_FACTORY_RAND_CHANCE = 0.004

# PHASE 6 CONSTANTS
const PHASE6_MAX_CONTRACTS = 10
const PHASE6_MAX_NUM_WOOD = 9
const PHASE6_MAX_NUM_METAL = 9
const PHASE6_MAX_NUM_CARRIAGES = 1
const PHASE6_MAX_PLANK_FACTORIES = 1
const PHASE6_MAX_INGOT_FACTORIES = 1
const PHASE6_MAX_CRATE_FACTORIES = 1
const PHASE6_WOOD_RAND_CHANCE = 0.004
const PHASE6_METAL_RAND_CHANCE = 0.004
const PHASE6_CONTRACT_RAND_CHANCE = 0.004
const PHASE6_CARRIAGE_RAND_CHANCE = 0.0004
const PHASE6_PLANK_FACTORY_RAND_CHANCE = 0.004
const PHASE6_INGOT_FACTORY_RAND_CHANCE = 0.004
const PHASE6_CRATE_FACTORY_RAND_CHANCE = 0.004

# PHASE 7 CONSTANTS
const PHASE7_MAX_CONTRACTS = 10
const PHASE7_MAX_NUM_WOOD = 9
const PHASE7_MAX_NUM_METAL = 9
const PHASE7_MAX_NUM_CARRIAGES = 1
const PHASE7_MAX_PLANK_FACTORIES = 2
const PHASE7_MAX_INGOT_FACTORIES = 2
const PHASE7_MAX_CRATE_FACTORIES = 1
const PHASE7_MAX_SHIPPING_CONTAINER_FACTORIES = 1
const PHASE7_WOOD_RAND_CHANCE = 0.004
const PHASE7_METAL_RAND_CHANCE = 0.004
const PHASE7_CONTRACT_RAND_CHANCE = 0.004
const PHASE7_CARRIAGE_RAND_CHANCE = 0.0004
const PHASE7_PLANK_FACTORY_RAND_CHANCE = 0.004
const PHASE7_INGOT_FACTORY_RAND_CHANCE = 0.004
const PHASE7_CRATE_FACTORY_RAND_CHANCE = 0.004
const PHASE7_SHIPPING_CONTAINER_FACTORY_RAND_CHANCE = 0.004

@onready var raw_resource_prefab = preload("res://Scenes/raw_resource_prefab.tscn")
@onready var contract_node_prefab = preload("res://Scenes/contract_node_prefab.tscn")
@onready var carriage_pickup_node_prefab = preload("res://Scenes/carriage_pickup_prefab.tscn")
@onready var factory_node_prefab = preload("res://Scenes/factory_node_prefab.tscn")
@onready var money_text = get_parent().get_node("Money_Text")
@onready var phase_text = get_parent().get_node("Phase_Label")

@export var ui_layer: CanvasLayer
@onready var floating_text_prefab = preload("res://Scenes/floating_text_prefab.tscn")
@export var checkpoint_node: Checkpoint_Node

@export var node_spawns: Node2D
@export var contract_spawns: Node2D
@export var factory_spawns: Node2D

@export var next_tax_label: Label

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

func spawn_factory(factory_type: GlobalVariables.FACTORY_TYPE, pos: Vector2) -> void:
	var chosen_x = pos.x
	var chosen_y = pos.y
	
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
	
func spawn_carriage(pos: Vector2) -> void:
	var chosen_x = pos.x
	var chosen_y = pos.y
	var carriage_pickup_node = carriage_pickup_node_prefab.instantiate() 
	add_child(carriage_pickup_node)
	carriage_pickup_node.position = Vector2(chosen_x, chosen_y)
	Stats.available_carriages += 1

func resolve_checkpoint():
	Stats.money -= checkpoint_tax
	Stats.total_loops += 1
	print("Loops: ", Stats.total_loops)
	
	var y = checkpoint_node.position.y - 128
	var x = checkpoint_node.position.x - 64
	var str = '- $' + str(checkpoint_tax)
	create_floating_text(Vector2(x,y), str, Color.RED, 120)
	
	SFXPlayer.play_audio_lost_money()
	
	# Each time we pass the checkpoint, increase the tax based on phase
	if current_phase == GAME_PHASE.PHASE1:
		checkpoint_tax += PHASE1_TAX_INCREASE
	elif current_phase == GAME_PHASE.PHASE2:
		checkpoint_tax += PHASE2_TAX_INCREASE
	elif current_phase == GAME_PHASE.PHASE3:
		checkpoint_tax += PHASE3_TAX_INCREASE
	elif current_phase == GAME_PHASE.PHASE4:
		checkpoint_tax += PHASE4_TAX_INCREASE
	elif current_phase == GAME_PHASE.PHASE5:
		checkpoint_tax += PHASE5_TAX_INCREASE
	elif current_phase == GAME_PHASE.PHASE6:
		checkpoint_tax += PHASE6_TAX_INCREASE
	elif current_phase == GAME_PHASE.PHASE7:
		checkpoint_tax += PHASE7_TAX_INCREASE
	
	# TODO: Visually notify player of tax increase
	
	if Stats.money >= 1:
		# TODO: Add a sound for lost money
		pass
	else:
		print("Lost the game!")
		Stats.previous_game_loops = Stats.total_loops
		Stats.apply_defaults()
		get_tree().change_scene_to_file("res://game_over.tscn")
		
	# Increment num loops since phase change
	num_loops_since_phase_change += 1
	
	# If 3 loops have passed, progress phase
	if num_loops_since_phase_change >= 3 and current_phase != GAME_PHASE.PHASE7:
		if current_phase == GAME_PHASE.PHASE1:
			current_phase = GAME_PHASE.PHASE2
			num_loops_since_phase_change = 0
		elif current_phase == GAME_PHASE.PHASE2:
			current_phase = GAME_PHASE.PHASE3
			num_loops_since_phase_change = 0
		elif current_phase == GAME_PHASE.PHASE3:
			current_phase = GAME_PHASE.PHASE4
			num_loops_since_phase_change = 0
		elif current_phase == GAME_PHASE.PHASE4:
			current_phase = GAME_PHASE.PHASE5
			num_loops_since_phase_change = 0
		elif current_phase == GAME_PHASE.PHASE5:
			current_phase = GAME_PHASE.PHASE6
			num_loops_since_phase_change = 0
		elif current_phase == GAME_PHASE.PHASE6:
			current_phase = GAME_PHASE.PHASE7
			num_loops_since_phase_change = 0

func create_floating_text(pos: Vector2, text: String, color: Color, frames: int):
	var floating_text = floating_text_prefab.instantiate()
	ui_layer.add_child(floating_text)
	floating_text.setup_floating_text(pos, text, color, frames)

func process_finite_state_machine():
	# PHASE 1
	# Resource Spawns: Wood
	# Contracts: Wood
	# Factories: (none)
	# Rent Increase Per Lap: 1
	
	phase_text.text = "Phase: " + str(current_phase + 1)
	
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
	# Rent Increase Per Lap: 2
	

	
	if current_phase == GAME_PHASE.PHASE2:
		var num_wood = 0
		var num_metal = 0
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
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.METAL
			):
				num_metal += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE2_MAX_NUM_WOOD and randf() < PHASE2_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_resource(selection, spawn.position)
					return
		
		# Spawn Metal resources if within limits
		if num_metal < PHASE2_MAX_NUM_METAL and randf() < PHASE2_METAL_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.METAL, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE2_MAX_CONTRACTS and randf() < PHASE2_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_contract(selection, spawn.position)
					return

	# PHASE 3
	# Resource Spawns: Wood, Metal, Carriages
	# Contracts: Wood, Metal
	# Factories: (none)
	# Rent Increase Per Lap: 3
	
	if current_phase == GAME_PHASE.PHASE3:
		var num_wood = 0
		var num_metal = 0
		var num_contracts = 0
		var num_carriages = 0
		var used_locations = []
		
		for child in get_children():
			if (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.WOOD
			):
				num_wood += 1
				used_locations.append(child.position)
			elif (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.METAL
			):
				num_metal += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
			elif (
				child is Carriage_Pickup_Node
			):
				num_carriages += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE3_MAX_NUM_WOOD and randf() < PHASE3_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
		
		# Spawn Metal resources if within limits
		if num_metal < PHASE3_MAX_NUM_METAL and randf() < PHASE3_METAL_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.METAL, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE3_MAX_CONTRACTS and randf() < PHASE3_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_contract(selection, spawn.position)
					return
		
		# Spawn Carriages if within limits
		if num_carriages < PHASE3_MAX_NUM_CARRIAGES and randf() < PHASE3_CARRIAGE_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_carriage(spawn.position)
					return

	# PHASE 4
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks
	# Factories: Planks
	# Rent Increase Per Lap: 5
	
	if current_phase == GAME_PHASE.PHASE4:
		var num_wood = 0
		var num_metal = 0
		var num_contracts = 0
		var num_carriages = 0
		var num_plank_factories = 0
		var used_locations = []
		
		for child in get_children():
			if (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.WOOD
			):
				num_wood += 1
				used_locations.append(child.position)
			elif (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.METAL
			):
				num_metal += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
			elif (
				child is Carriage_Pickup_Node
			):
				num_carriages += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.PLANK
			):
				num_plank_factories += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE4_MAX_NUM_WOOD and randf() < PHASE4_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
		
		# Spawn Metal resources if within limits
		if num_metal < PHASE4_MAX_NUM_METAL and randf() < PHASE4_METAL_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.METAL, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE4_MAX_CONTRACTS and randf() < PHASE4_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_contract(selection, spawn.position)
					return
		
		# Spawn Carriages if within limits
		if num_carriages < PHASE4_MAX_NUM_CARRIAGES and randf() < PHASE4_CARRIAGE_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_carriage(spawn.position)
					return
		
		# Spawn Plank Factories if within limits
		if num_plank_factories < PHASE4_MAX_PLANK_FACTORIES and randf() < PHASE4_PLANK_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.PLANK, spawn.position)
					return
	
	# PHASE 5
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks, Ingots
	# Factories: Planks, Ingots
	# Rent Increase Per Lap: 10
	
	if current_phase == GAME_PHASE.PHASE5:
		var num_wood = 0
		var num_metal = 0
		var num_contracts = 0
		var num_carriages = 0
		var num_plank_factories = 0
		var num_ingot_factories = 0
		var used_locations = []
		
		for child in get_children():
			if (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.WOOD
			):
				num_wood += 1
				used_locations.append(child.position)
			elif (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.METAL
			):
				num_metal += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
			elif (
				child is Carriage_Pickup_Node
			):
				num_carriages += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.PLANK
			):
				num_plank_factories += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.INGOT
			):
				num_ingot_factories += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE5_MAX_NUM_WOOD and randf() < PHASE5_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
		
		# Spawn Metal resources if within limits
		if num_metal < PHASE5_MAX_NUM_METAL and randf() < PHASE5_METAL_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.METAL, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE5_MAX_CONTRACTS and randf() < PHASE5_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_contract(selection, spawn.position)
					return
		
		# Spawn Carriages if within limits
		if num_carriages < PHASE5_MAX_NUM_CARRIAGES and randf() < PHASE5_CARRIAGE_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_carriage(spawn.position)
					return
		
		# Spawn Plank Factories if within limits
		if num_plank_factories < PHASE5_MAX_PLANK_FACTORIES and randf() < PHASE5_PLANK_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.PLANK, spawn.position)
					return
		
		# Spawn Ingot factories if within limits
		if num_ingot_factories < PHASE5_MAX_INGOT_FACTORIES and randf() < PHASE5_INGOT_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.INGOT, spawn.position)
					return
	
	# PHASE 6
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks, Ingots, Crates
	# Factories: Planks, Ingots, Crates
	# Rent Increase Per Lap: 15
	
	
	if current_phase == GAME_PHASE.PHASE6:
		var num_wood = 0
		var num_metal = 0
		var num_contracts = 0
		var num_carriages = 0
		var num_plank_factories = 0
		var num_ingot_factories = 0
		var num_crate_factories = 0
		var used_locations = []
		
		for child in get_children():
			if (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.WOOD
			):
				num_wood += 1
				used_locations.append(child.position)
			elif (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.METAL
			):
				num_metal += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
			elif (
				child is Carriage_Pickup_Node
			):
				num_carriages += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.PLANK
			):
				num_plank_factories += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.INGOT
			):
				num_ingot_factories += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.CRATE
			):
				num_crate_factories += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE6_MAX_NUM_WOOD and randf() < PHASE6_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
		
		# Spawn Metal resources if within limits
		if num_metal < PHASE6_MAX_NUM_METAL and randf() < PHASE6_METAL_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.METAL, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE6_MAX_CONTRACTS and randf() < PHASE6_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT, GlobalVariables.RESOURCE_TYPE.CRATE]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_contract(selection, spawn.position)
					return
		
		# Spawn Carriages if within limits
		if num_carriages < PHASE6_MAX_NUM_CARRIAGES and randf() < PHASE6_CARRIAGE_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_carriage(spawn.position)
					return
		
		# Spawn Plank Factories if within limits
		if num_plank_factories < PHASE6_MAX_PLANK_FACTORIES and randf() < PHASE6_PLANK_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.PLANK, spawn.position)
					return
		
		# Spawn Ingot factories if within limits
		if num_ingot_factories < PHASE6_MAX_INGOT_FACTORIES and randf() < PHASE6_INGOT_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.INGOT, spawn.position)
					return
		
		# Spawn Crate factories if within limits
		if num_crate_factories < PHASE6_MAX_CRATE_FACTORIES and randf() < PHASE6_CRATE_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.CRATE, spawn.position)
					return
	
	# PHASE 7
	# Resource Spawns: Wood, Metal
	# Contracts: Wood, Metal, Planks, Ingots, Crates, Shipping Containers
	# Factories: Planks, Ingots, Crates, Shipping Containers
	# Rent Increase Per Lap: 20
	
	
	if current_phase == GAME_PHASE.PHASE7:
		var num_wood = 0
		var num_metal = 0
		var num_contracts = 0
		var num_carriages = 0
		var num_plank_factories = 0
		var num_ingot_factories = 0
		var num_crate_factories = 0
		var num_shipping_container_factories = 0
		var used_locations = []
		
		for child in get_children():
			if (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.WOOD
			):
				num_wood += 1
				used_locations.append(child.position)
			elif (
				child is Raw_Resource
				and child.resource_type == GlobalVariables.RESOURCE_TYPE.METAL
			):
				num_metal += 1
				used_locations.append(child.position)
			elif (
				child is Contract_Node
			):
				num_contracts += 1
				used_locations.append(child.position)
			elif (
				child is Carriage_Pickup_Node
			):
				num_carriages += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.PLANK
			):
				num_plank_factories += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.INGOT
			):
				num_ingot_factories += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.CRATE
			):
				num_crate_factories += 1
				used_locations.append(child.position)
			elif (
				child is Factory_Node
				and child.factory_type == GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER
			):
				num_shipping_container_factories += 1
				used_locations.append(child.position)
		
		# Spawn Wood resources if within limits
		if num_wood < PHASE7_MAX_NUM_WOOD and randf() < PHASE7_WOOD_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.WOOD, spawn.position)
					return
		
		# Spawn Metal resources if within limits
		if num_metal < PHASE7_MAX_NUM_METAL and randf() < PHASE7_METAL_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_resource(GlobalVariables.RESOURCE_TYPE.METAL, spawn.position)
					return
		
		# Spawn Contracts if within limits
		if num_contracts < PHASE7_MAX_CONTRACTS and randf() < PHASE7_CONTRACT_RAND_CHANCE:
			while true:
				var rand = randi_range(0, contract_spawns.get_child_count() - 1)
				var spawn = contract_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					var possible_contracts = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT, GlobalVariables.RESOURCE_TYPE.CRATE, GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER]
					var selection = possible_contracts[randi() % possible_contracts.size()]
					
					spawn_contract(selection, spawn.position)
					return
		
		# Spawn Carriages if within limits
		if num_carriages < PHASE7_MAX_NUM_CARRIAGES and randf() < PHASE7_CARRIAGE_RAND_CHANCE:
			while true:
				var rand = randi_range(0, node_spawns.get_child_count() - 1)
				var spawn = node_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_carriage(spawn.position)
					return
		
		# Spawn Plank Factories if within limits
		if num_plank_factories < PHASE7_MAX_PLANK_FACTORIES and randf() < PHASE7_PLANK_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.PLANK, spawn.position)
					return
		
		# Spawn Ingot factories if within limits
		if num_ingot_factories < PHASE7_MAX_INGOT_FACTORIES and randf() < PHASE7_INGOT_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.INGOT, spawn.position)
					return
		
		# Spawn Crate factories if within limits
		if num_crate_factories < PHASE7_MAX_CRATE_FACTORIES and randf() < PHASE7_CRATE_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.CRATE, spawn.position)
					return
		
		# Spawn shipping container factories if within limits
		if num_shipping_container_factories < PHASE7_MAX_SHIPPING_CONTAINER_FACTORIES and randf() < PHASE7_SHIPPING_CONTAINER_FACTORY_RAND_CHANCE:
			while true:
				var rand = randi_range(0, factory_spawns.get_child_count() - 1)
				var spawn = factory_spawns.get_child(rand)
				
				if spawn.position in used_locations:
					# Keep looking for a spawn that is not taken
					continue
				else:
					spawn_factory(GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER, spawn.position)
					return

func _process(delta: float) -> void:
	money_text.text = 'Money: $ ' + str(Stats.money) + ' (Loops: ' + str(Stats.total_loops) + ')'
	next_tax_label.text = '($' + str(checkpoint_tax) + ')'

func _physics_process(delta: float) -> void:
	process_finite_state_machine()

func _ready() -> void:
	MusicPlayer.play_background_music()
