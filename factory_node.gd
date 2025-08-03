extends RigidBody2D
class_name Factory_Node

var factory_type: GlobalVariables.FACTORY_TYPE = GlobalVariables.FACTORY_TYPE.NONE

var selected_by_player: bool = false
var resources_invested: Array[GlobalVariables.RESOURCE_TYPE] = []

@onready var sprite2d = get_node("Sprite2D")
@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")

@onready var single_input_sprite = get_node("Single_Input_Sprite")
@onready var left_input_sprite = get_node("Left_Input_Sprite")
@onready var right_input_sprite = get_node("Right_Input_Sprite")
@onready var output_sprite = get_node("Output_Sprite")

@onready var plank_sprite = preload("res://Assets/Factory1.png")
@onready var ingot_sprite = preload("res://Assets/Factory2.png")
@onready var crate_sprite = preload("res://Assets/Factory3.png")
@onready var shipping_container_sprite = preload("res://Assets/Factory4.png")

func set_factory_type(type: GlobalVariables.FACTORY_TYPE):
	factory_type = type
	
	if factory_type == GlobalVariables.FACTORY_TYPE.PLANK:
		# PLANK RECIPE: 1 Wood = 1 Plank
		
		# Select correct factory sprite
		sprite2d.texture = plank_sprite
		
		# Generate recipe icons
		single_input_sprite.texture = GlobalVariables.wood_sprite
		single_input_sprite.visible = true
		
		# Generate output icon (lower opacity by default)
		output_sprite.texture = GlobalVariables.plank_sprite
		output_sprite.visible = true
	elif factory_type == GlobalVariables.FACTORY_TYPE.INGOT:
		# INGOT RECIPE: 1 Metal = 1 Ingot
		
		# Select correct factory sprite
		sprite2d.texture = ingot_sprite
		
		# Generate recipe icons
		single_input_sprite.texture = GlobalVariables.ingot_sprite
		single_input_sprite.visible = true
		
		# Generate output icon (lower opacity by default)
		output_sprite.texture = GlobalVariables.ingot_sprite
		output_sprite.visible = true
	elif factory_type == GlobalVariables.FACTORY_TYPE.CRATE:
		# CRATE RECIPE: 1 Metal, 1 Wood = 1 Crate
		
		# Select correct factory sprite
		sprite2d.texture = crate_sprite
		
		# Generate recipe icons (half opacity by default)
		left_input_sprite.texture = GlobalVariables.wood_sprite
		left_input_sprite.visible = true
		
		right_input_sprite.texture = GlobalVariables.metal_sprite
		right_input_sprite.visible = true
		
		# Generate output icon (half opacity by default)
		output_sprite.texture = GlobalVariables.crate_sprite
		output_sprite.visible = true
	elif factory_type == GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER:
		# SHIPPING CONT. RECIPE: 1 Plank, 1 Ingot = 1 Shipping Container
		
		# Select correct factory sprite
		sprite2d.texture = shipping_container_sprite
		
		# Generate recipe icons (half opacity by default)
		left_input_sprite.texture = GlobalVariables.plank_sprite
		left_input_sprite.visible = true
		
		right_input_sprite.texture = GlobalVariables.ingot_sprite
		right_input_sprite.visible = true
		
		# Generate output icon (half opacity by default)
		output_sprite.texture = GlobalVariables.shipping_container_sprite
		output_sprite.visible = true
	else:
		print("Error! Attempted to create an invalid factory type.")

func insert_resource(type: GlobalVariables.RESOURCE_TYPE):
	# Deal with incoming type depending on what the factory is
	
	if factory_type == GlobalVariables.FACTORY_TYPE.PLANK:
		if type == GlobalVariables.RESOURCE_TYPE.WOOD:
			print("Successfully gave wood to plank factory!")
			pass #TODO: Success!
		else:
			SFXPlayer.play_failed_action()
	elif factory_type == GlobalVariables.FACTORY_TYPE.INGOT:
		if type == GlobalVariables.RESOURCE_TYPE.METAL:
			print("Successfully gave metal to ingot factory!")
			pass # TODO: Success!
		else:
			SFXPlayer.play_failed_action()
	elif factory_type == GlobalVariables.FACTORY_TYPE.CRATE:
		if (
			type in [GlobalVariables.RESOURCE_TYPE.WOOD, GlobalVariables.RESOURCE_TYPE.METAL]
			and type not in resources_invested
		):
			print("Successfully gave ? to crate factory!")
			pass # TODO: Success!
		else:
			SFXPlayer.play_failed_action()
	elif factory_type == GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER:
		if (
			type in [GlobalVariables.RESOURCE_TYPE.PLANK, GlobalVariables.RESOURCE_TYPE.INGOT]
			and type not in resources_invested
		):
			print("Successfully gave ? to shipping cont. factory!")
			pass # TODO: Success!
		else:
			SFXPlayer.play_failed_action()
	else:
		print("Error! Tried to insert resources into an uninitialised factory.")

func toggle_factory_select():
	if selected_by_player:
		selected_by_player = false
		sprite2d.material = null
	elif !selected_by_player:
		selected_by_player = true
		sprite2d.material = highlighted_material

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		toggle_factory_select()
