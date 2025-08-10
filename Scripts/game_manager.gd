extends Node2D
class_name Game_Manager

# This is just a test

enum Game_Phase {PHASE1, PHASE2, PHASE3, PHASE4, PHASE5, PHASE6, PHASE7}
var current_phase: Game_Phase = Game_Phase.PHASE1
var num_loops_since_phase_change = -1

var num_loops_in_phase = {
	Game_Phase.PHASE1: 3,
	Game_Phase.PHASE2: 1,
	Game_Phase.PHASE3: 2,
	Game_Phase.PHASE4: 5,
	Game_Phase.PHASE5: 5,
	Game_Phase.PHASE6: 5,
	Game_Phase.PHASE7: -1 # Game remains on Phase 7 forever
}

var checkpoint_tax = 1
var tax_increase = {
	Game_Phase.PHASE1: 1,
	Game_Phase.PHASE2: 1,
	Game_Phase.PHASE3: 1,
	Game_Phase.PHASE4: 1,
	Game_Phase.PHASE5: 1,
	Game_Phase.PHASE6: 1,
	Game_Phase.PHASE7: 1
}

var max_contracts = {
	Game_Phase.PHASE1: 4,
	Game_Phase.PHASE2: 8,
	Game_Phase.PHASE3: 8,
	Game_Phase.PHASE4: 10,
	Game_Phase.PHASE5: 10,
	Game_Phase.PHASE6: 10,
	Game_Phase.PHASE7: 10
}

var max_num_wood = {
	Game_Phase.PHASE1: 4,
	Game_Phase.PHASE2: 4,
	Game_Phase.PHASE3: 6,
	Game_Phase.PHASE4: 7,
	Game_Phase.PHASE5: 8,
	Game_Phase.PHASE6: 9,
	Game_Phase.PHASE7: 9
}

var max_num_metal = {
	Game_Phase.PHASE1: 0, # None this phase
	Game_Phase.PHASE2: 4,
	Game_Phase.PHASE3: 6,
	Game_Phase.PHASE4: 7,
	Game_Phase.PHASE5: 8,
	Game_Phase.PHASE6: 9,
	Game_Phase.PHASE7: 9
}

var max_num_carriages = {
	Game_Phase.PHASE1: 0, # None this phase
	Game_Phase.PHASE2: 0, # None this phase
	Game_Phase.PHASE3: 1,
	Game_Phase.PHASE4: 1,
	Game_Phase.PHASE5: 1,
	Game_Phase.PHASE6: 1,
	Game_Phase.PHASE7: 1
}

var wood_rand_chance = {
	Game_Phase.PHASE1: 0.003,
	Game_Phase.PHASE2: 0.004,
	Game_Phase.PHASE3: 0.004,
	Game_Phase.PHASE4: 0.004,
	Game_Phase.PHASE5: 0.004,
	Game_Phase.PHASE6: 0.004,
	Game_Phase.PHASE7: 0.004
}

var metal_rand_chance = {
	Game_Phase.PHASE1: 0, # None this phase
	Game_Phase.PHASE2: 0.004,
	Game_Phase.PHASE3: 0.004,
	Game_Phase.PHASE4: 0.004,
	Game_Phase.PHASE5: 0.004,
	Game_Phase.PHASE6: 0.004,
	Game_Phase.PHASE7: 0.004
}

var contract_rand_chance = {
	Game_Phase.PHASE1: 0.003,
	Game_Phase.PHASE2: 0.004,
	Game_Phase.PHASE3: 0.004,
	Game_Phase.PHASE4: 0.004,
	Game_Phase.PHASE5: 0.004,
	Game_Phase.PHASE6: 0.004,
	Game_Phase.PHASE7: 0.004
}

var carriage_rand_chance = {
	Game_Phase.PHASE1: 0, # None this phase
	Game_Phase.PHASE2: 0, # None this phase
	Game_Phase.PHASE3: 0.004,
	Game_Phase.PHASE4: 0.004,
	Game_Phase.PHASE5: 0.004,
	Game_Phase.PHASE6: 0.004,
	Game_Phase.PHASE7: 0.004
}

var max_factories = {
	GlobalVariables.FACTORY_TYPE.PLANK: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 1,
		Game_Phase.PHASE5: 1,
		Game_Phase.PHASE6: 1,
		Game_Phase.PHASE7: 2
	},
	GlobalVariables.FACTORY_TYPE.INGOT: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 0, # None this phase
		Game_Phase.PHASE5: 1,
		Game_Phase.PHASE6: 1,
		Game_Phase.PHASE7: 2
	},
	GlobalVariables.FACTORY_TYPE.CRATE: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 0, # None this phase
		Game_Phase.PHASE5: 0, # None this phase
		Game_Phase.PHASE6: 1,
		Game_Phase.PHASE7: 1
	},
	GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 0, # None this phase
		Game_Phase.PHASE5: 0, # None this phase
		Game_Phase.PHASE6: 0, # None this phase
		Game_Phase.PHASE7: 1
	}
}

var possible_contracts = {
	Game_Phase.PHASE1: [GlobalVariables.RESOURCE_TYPE.WOOD], # Wood
	Game_Phase.PHASE2: [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL], # Wood, Metal
	Game_Phase.PHASE3: [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL], # Wood, Metal
	Game_Phase.PHASE4: [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK], # Wood, Metal, Planks
	Game_Phase.PHASE5: [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT], # Wood, Metal, Planks, Ingots
	Game_Phase.PHASE6: [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT, GlobalVariables.RESOURCE_TYPE.CRATE], # Wood, Metal, Planks, Ingots, Crates
	Game_Phase.PHASE7: [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL, GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT, GlobalVariables.RESOURCE_TYPE.CRATE, GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER] # Wood, Metal, Planks, Ingots, Crates, Shipping Containers
}

var carriage_cost = {
	Game_Phase.PHASE1: null, # None this phase
	Game_Phase.PHASE2: null, # None this phase
	Game_Phase.PHASE3: 30,
	Game_Phase.PHASE4: 45,
	Game_Phase.PHASE5: 70,
	Game_Phase.PHASE6: 110,
	Game_Phase.PHASE7: 165
}

var contract_money = {
	GlobalVariables.RESOURCE_TYPE.WOOD: {
		Game_Phase.PHASE1: 5,
		Game_Phase.PHASE2: 5,
		Game_Phase.PHASE3: 5,
		Game_Phase.PHASE4: 10,
		Game_Phase.PHASE5: 10,
		Game_Phase.PHASE6: 10,
		Game_Phase.PHASE7: 20
	},
	GlobalVariables.RESOURCE_TYPE.METAL: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 5,
		Game_Phase.PHASE3: 5,
		Game_Phase.PHASE4: 10,
		Game_Phase.PHASE5: 10,
		Game_Phase.PHASE6: 10,
		Game_Phase.PHASE7: 10
	},
	GlobalVariables.RESOURCE_TYPE.PLANK: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 25,
		Game_Phase.PHASE5: 25,
		Game_Phase.PHASE6: 35,
		Game_Phase.PHASE7: 35
	},
	GlobalVariables.RESOURCE_TYPE.INGOT: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 0, # None this phase
		Game_Phase.PHASE5: 25,
		Game_Phase.PHASE6: 35,
		Game_Phase.PHASE7: 35
	},
	GlobalVariables.RESOURCE_TYPE.CRATE: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 0, # None this phase
		Game_Phase.PHASE5: 0, # None this phase
		Game_Phase.PHASE6: 45,
		Game_Phase.PHASE7: 60
	},
	GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER: {
		Game_Phase.PHASE1: 0, # None this phase
		Game_Phase.PHASE2: 0, # None this phase
		Game_Phase.PHASE3: 0, # None this phase
		Game_Phase.PHASE4: 0, # None this phase
		Game_Phase.PHASE5: 0, # None this phase
		Game_Phase.PHASE6: 0, # None this phase
		Game_Phase.PHASE7: 100
	}
}

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
	carriage_pickup_node.cost = carriage_cost[current_phase]
	Stats.available_carriages += 1

func resolve_checkpoint():
	Stats.money -= checkpoint_tax
	Stats.total_loops += 1
	print("Loops: ", Stats.total_loops)
	
	var y = checkpoint_node.position.y - 128
	var x = checkpoint_node.position.x - 64
	var string = '- $' + str(checkpoint_tax)
	create_floating_text(Vector2(x,y), string, Color.RED, 120)
	
	SFXPlayer.play_audio_lost_money()
	
	# Each time we pass the checkpoint, increase the tax based on phase
	checkpoint_tax += tax_increase[current_phase]
	
	if Stats.money < 1:
		# Bankrupted!
		Stats.previous_game_loops = Stats.total_loops
		Stats.apply_defaults()
		get_tree().change_scene_to_file("res://Levels/game_over.tscn")
		
	# Increment num loops since phase change
	num_loops_since_phase_change += 1
	
	# If 3 loops have passed, progress phase
	if num_loops_since_phase_change >= num_loops_in_phase[current_phase] and current_phase != Game_Phase.PHASE7:
		num_loops_since_phase_change = 0

		if current_phase == Game_Phase.PHASE1:
			current_phase = Game_Phase.PHASE2
		elif current_phase == Game_Phase.PHASE2:
			current_phase = Game_Phase.PHASE3
		elif current_phase == Game_Phase.PHASE3:
			current_phase = Game_Phase.PHASE4
		elif current_phase == Game_Phase.PHASE4:
			current_phase = Game_Phase.PHASE5
		elif current_phase == Game_Phase.PHASE5:
			current_phase = Game_Phase.PHASE6
		elif current_phase == Game_Phase.PHASE6:
			current_phase = Game_Phase.PHASE7

func create_floating_text(pos: Vector2, text: String, color: Color, frames: int):
	var floating_text = floating_text_prefab.instantiate()
	ui_layer.add_child(floating_text)
	floating_text.setup_floating_text(pos, text, color, frames)

func process_finite_state_machine():
	phase_text.text = "(DEBUG ONLY) Phase: " + str(current_phase + 1)

	var num_carriages = 0
	var num_contracts = 0

	var num_resources = {
		GlobalVariables.RESOURCE_TYPE.WOOD: 0,
		GlobalVariables.RESOURCE_TYPE.METAL: 0
	}

	var num_factories = {
		GlobalVariables.FACTORY_TYPE.PLANK: 0,
		GlobalVariables.FACTORY_TYPE.INGOT: 0,
		GlobalVariables.FACTORY_TYPE.CRATE: 0,
		GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER: 0
	}

	var contract_counts = {
		GlobalVariables.RESOURCE_TYPE.WOOD: 0,
		GlobalVariables.RESOURCE_TYPE.METAL: 0,
		GlobalVariables.RESOURCE_TYPE.PLANK: 0,
		GlobalVariables.RESOURCE_TYPE.INGOT: 0,
		GlobalVariables.RESOURCE_TYPE.CRATE: 0,
		GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER: 0
	}

	var used_locations = []
	
	for child in get_children():
		if (
			child is Raw_Resource
		):
			num_resources[child.resource_type] += 1
			used_locations.append(child.position)
		elif (
			child is Contract_Node
		):
			num_contracts += 1
			contract_counts[child.contract_type] += 1
			used_locations.append(child.position)
		elif (
			child is Carriage_Pickup_Node
		):
			num_carriages += 1
			used_locations.append(child.position)
		elif (
			child is Factory_Node
		):
			num_factories[child.factory_type] += 1
			used_locations.append(child.position)
	
	# Spawn Wood resources if within limits
	if num_resources[GlobalVariables.RESOURCE_TYPE.WOOD] < max_num_wood[current_phase] and randf() < wood_rand_chance[current_phase]:
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
	if num_resources[GlobalVariables.RESOURCE_TYPE.METAL] < max_num_metal[current_phase] and randf() < metal_rand_chance[current_phase]:
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
	if num_contracts < max_contracts[current_phase] and randf() < contract_rand_chance[current_phase]:
		while true:
			var rand = randi_range(0, contract_spawns.get_child_count() - 1)
			var spawn = contract_spawns.get_child(rand)
			
			if spawn.position in used_locations:
				# Keep looking for a spawn that is not taken
				continue
			else:
				var selection = null
				
				# Attempt to select a contract type that represents less than half of all possible contracts
				while (selection == null):
					# Select a random resource from possible contracts this phase, check for suitability afterwards
					var temp = possible_contracts[current_phase][randi() % possible_contracts[current_phase].size()]
					
					if current_phase == Game_Phase.PHASE1 or contract_counts[temp] < max_contracts[current_phase] / 2:
						# If we are in Phase 1, or if this resource accounts for less than half of all possible contracts, select it
						selection = temp

				spawn_contract(selection, spawn.position)
				return
	
	# Spawn Carriages if within limits
	if num_carriages < max_num_carriages[current_phase] and randf() < carriage_rand_chance[current_phase]:
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
	if num_factories[GlobalVariables.FACTORY_TYPE.PLANK] < max_factories[GlobalVariables.FACTORY_TYPE.PLANK][current_phase]:
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
	if num_factories[GlobalVariables.FACTORY_TYPE.INGOT] < max_factories[GlobalVariables.FACTORY_TYPE.INGOT][current_phase]:
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
	if num_factories[GlobalVariables.FACTORY_TYPE.CRATE] < max_factories[GlobalVariables.FACTORY_TYPE.CRATE][current_phase]:
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
	if num_factories[GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER] < max_factories[GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER][current_phase]:
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
