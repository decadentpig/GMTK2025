extends Node2D
class_name Game_Manager

const RESOURCE_SPAWN_CHANCE = 0.002
#const RESOURCE_SPAWN_CHANCE = 0.01 # FULL SPEEEED
const RESOURCE_SPAWN_TRACK_OFFSET = 120
const CARRIAGE_SIZE = 128
const CONTRACT_SPAWN_CHANCE = 0.001
const CARRIAGE_SPAWN_CHANCE = 0.0002
const CARRIAGE_SPAWN_AFTER_CONTRACTS = 5

@onready var raw_resource_prefab = preload("res://Scenes/raw_resource_prefab.tscn")
@onready var contract_node_prefab = preload("res://Scenes/contract_node_prefab.tscn")
@onready var carriage_pickup_node_prefab = preload("res://Scenes/carriage_pickup_prefab.tscn")
@onready var money_text = get_parent().get_node("Money_Text")

@export var ui_layer: CanvasLayer
@onready var floating_text_prefab = preload("res://Scenes/floating_text_prefab.tscn")
@export var checkpoint_node: Checkpoint_Node
@export var node_spawns: Node2D

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
	
func get_random_resource() -> GlobalVariables.RESOURCE_TYPE:
	var resources = [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL]
	var resource_type_index = randi() % resources.size()
	return resources[resource_type_index]

func spawn_resource() -> void:
	var spawn_location = get_item_spawn_location()
	var chosen_x = spawn_location[0]
	var chosen_y = spawn_location[1]
	
	# Choose resouce type
	var resource_type = get_random_resource()

	# Spawn on grid 
	var resource = raw_resource_prefab.instantiate()
	add_child(resource)
	resource.set_resource_type(resource_type)
	resource.position = Vector2(chosen_x, chosen_y)
	
func spawn_contract() -> void:
	var spawn_location = get_item_spawn_location()
	var chosen_x = spawn_location[0]
	var chosen_y = spawn_location[1]
	
	# Choose resouce type
	var resource_type = get_random_resource()

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

func _process(delta: float) -> void:
	if randf() < RESOURCE_SPAWN_CHANCE:
		spawn_resource()
		
	if randf() < CONTRACT_SPAWN_CHANCE:
		spawn_contract()
		
	if (
		randf() < CARRIAGE_SPAWN_CHANCE
		and Stats.contracts_complete > CARRIAGE_SPAWN_AFTER_CONTRACTS
		and Stats.available_carriages < GlobalVariables.MAX_CARRIAGE_PICKUPS
	):
		spawn_carriage()
#
	money_text.text = str(Stats.money)

func _ready() -> void:
	spawn_resource()
	spawn_contract()
	MusicPlayer.play_background_music()
