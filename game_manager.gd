extends Node2D

#const RESOURCE_SPAWN_CHANCE = 0.001
const RESOURCE_SPAWN_CHANCE = 0.01 # FULL SPEEEED
const RESOURCE_SPAWN_TRACK_OFFSET = 120
const CARRIAGE_SIZE = 128
const CONTRACT_SPAWN_CHANCE = 0.0005

@onready var raw_resource_prefab = preload("res://Scenes/raw_resource_prefab.tscn")
@onready var contract_node_prefab = preload("res://Scenes/contract_node_prefab.tscn")

func func_get_cord_for_side(side: Variant) -> int:
	var chosen_cord = null
	if typeof(side) == TYPE_INT:
		return side
	elif typeof(side) == TYPE_ARRAY:
		return randi_range(side[0], side[1])
	else:
		print("ERROR", side)
		return 0
	
	
func get_item_spawn_location() -> Array:
	var top_left_point = {"x": 300, "y": 320}
	var bottom_left_point = {"x": 300, "y": 1030}
	var bottom_right_point = {"x": 2100, "y": 1030}
	var top_right_point = {"x": 2100, "y": 320}
	
	var sides = [
		# Outer left
		{"x": top_left_point["x"] - RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_left_point["y"] + CARRIAGE_SIZE, bottom_left_point["y"] - CARRIAGE_SIZE]},
		# Inner left
		{"x": top_left_point["x"] + RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_left_point["y"] + CARRIAGE_SIZE, bottom_left_point["y"] - CARRIAGE_SIZE]},
		# Outer bottom
		{"x": [bottom_left_point["x"] + CARRIAGE_SIZE, bottom_right_point["x"] - CARRIAGE_SIZE], "y": bottom_left_point["y"] + RESOURCE_SPAWN_TRACK_OFFSET},
		# Inner bottom
		{"x": [bottom_left_point["x"] + CARRIAGE_SIZE, bottom_right_point["x"] - CARRIAGE_SIZE], "y": bottom_left_point["y"] - RESOURCE_SPAWN_TRACK_OFFSET},
		# Outer right
		{"x": bottom_right_point["x"] + RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_right_point["y"] + CARRIAGE_SIZE, bottom_right_point["y"] - CARRIAGE_SIZE]},
		# Inner right
		{"x": bottom_right_point["x"] - RESOURCE_SPAWN_TRACK_OFFSET, "y": [top_right_point["y"] + CARRIAGE_SIZE, bottom_right_point["y"] - CARRIAGE_SIZE]},
		# Outer top
		{"x": [top_left_point["x"] + CARRIAGE_SIZE, top_right_point["x"] - CARRIAGE_SIZE], "y": top_right_point["y"] - RESOURCE_SPAWN_TRACK_OFFSET},
		# Inner top
		{"x": [top_left_point["x"] + CARRIAGE_SIZE, top_right_point["x"] - CARRIAGE_SIZE], "y": top_right_point["y"] + RESOURCE_SPAWN_TRACK_OFFSET},
	]
	
		
	# Pick side that resource spawns on
	var random_side_index = randi() % sides.size()
	var chosen_side = sides[random_side_index]
	
	# Choose spawn location on side
	var chosen_x = func_get_cord_for_side(chosen_side["x"])
	var chosen_y = func_get_cord_for_side(chosen_side["y"])
	
	return [chosen_x, chosen_y]
	
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
	var resource = raw_resource_prefab.instantiate()
	add_child(resource)
	resource.set_resource_type(resource_type)
	resource.position = Vector2(chosen_x, chosen_y)


func _process(delta: float) -> void:
	if randf() < RESOURCE_SPAWN_CHANCE:
		spawn_resource()

#
func _ready() -> void:
	spawn_resource()
