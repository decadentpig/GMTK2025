extends RigidBody2D
class_name Factory_Node

var factory_type: GlobalVariables.FACTORY_TYPE = GlobalVariables.FACTORY_TYPE.NONE

var accepting_inputs: bool = true
var has_output: bool = false

var processing_percentage: float = 0.0
const PROCESSING_STEP = 25

var output_resource: GlobalVariables.RESOURCE_TYPE = GlobalVariables.RESOURCE_TYPE.NONE

var selected_by_player: bool = false
var resources_invested: Array[GlobalVariables.RESOURCE_TYPE] = []

@onready var sprite2d = get_node("Sprite2D")
@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")

@onready var single_input_sprite = get_node("Single_Input_Sprite")
@onready var left_input_sprite = get_node("Left_Input_Sprite")
@onready var right_input_sprite = get_node("Right_Input_Sprite")
@onready var output_sprite = get_node("Output_Sprite")

@onready var progress_bar = get_node("Control").get_node("ProgressBar")
@onready var smoke_animation = get_node("Smoke_Animation")

@onready var chibi_wood = preload("res://Assets/Chibi-Wood.png")
@onready var chibi_metal = preload("res://Assets/Chibi-Rock.png")
@onready var chibi_plank = preload("res://Assets/Chibi-Planks.png")
@onready var chibi_ingot = preload("res://Assets/Chibi-Ingot.png")

func set_factory_type(type: GlobalVariables.FACTORY_TYPE):
	factory_type = type
	
	# Add defaults so this function can be reused each time factory resets
	accepting_inputs = true
	has_output = false
	processing_percentage = 0
	output_resource = GlobalVariables.RESOURCE_TYPE.NONE
	
	output_sprite.modulate.a = 128
	single_input_sprite.modulate.a = 128
	left_input_sprite.modulate.a = 128
	right_input_sprite.modulate.a = 128
	
	output_sprite.material = null
	single_input_sprite.material = null
	left_input_sprite.material = null
	right_input_sprite.material = null
	
	if factory_type == GlobalVariables.FACTORY_TYPE.PLANK:
		# PLANK RECIPE: 1 Wood = 1 Plank
		output_resource = GlobalVariables.RESOURCE_TYPE.PLANK
		
		# Generate recipe icons
		single_input_sprite.texture = chibi_wood
		single_input_sprite.visible = true
		
		# Generate output icon (lower opacity by default)
		output_sprite.texture = GlobalVariables.plank_sprite
		output_sprite.visible = true
	elif factory_type == GlobalVariables.FACTORY_TYPE.INGOT:
		# INGOT RECIPE: 1 Metal = 1 Ingot
		output_resource = GlobalVariables.RESOURCE_TYPE.INGOT
		
		# Generate recipe icons
		single_input_sprite.texture = chibi_metal
		single_input_sprite.visible = true
		
		# Generate output icon (lower opacity by default)
		output_sprite.texture = GlobalVariables.ingot_sprite
		output_sprite.visible = true
	elif factory_type == GlobalVariables.FACTORY_TYPE.CRATE:
		# CRATE RECIPE: 1 Metal, 1 Wood = 1 Crate
		output_resource = GlobalVariables.RESOURCE_TYPE.CRATE
		
		# Generate recipe icons (half opacity by default)
		left_input_sprite.texture = chibi_wood
		left_input_sprite.visible = true
		
		right_input_sprite.texture = chibi_metal
		right_input_sprite.visible = true
		
		# Generate output icon (half opacity by default)
		output_sprite.texture = GlobalVariables.crate_sprite
		output_sprite.visible = true
	elif factory_type == GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER:
		# SHIPPING CONT. RECIPE: 1 Plank, 1 Ingot = 1 Shipping Container
		output_resource = GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER
		
		# Generate recipe icons (half opacity by default)
		left_input_sprite.texture = chibi_plank
		left_input_sprite.visible = true
		
		right_input_sprite.texture = chibi_ingot
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
			single_input_sprite.modulate.a = 255
			single_input_sprite.material = highlighted_material
			resources_invested.append(GlobalVariables.RESOURCE_TYPE.WOOD)
			
			if selected_by_player:
				toggle_factory_select()
		else:
			SFXPlayer.play_failed_action()
	elif factory_type == GlobalVariables.FACTORY_TYPE.INGOT:
		if type == GlobalVariables.RESOURCE_TYPE.METAL:
			single_input_sprite.modulate.a = 255
			single_input_sprite.material = highlighted_material
			resources_invested.append(GlobalVariables.RESOURCE_TYPE.METAL)
			
			if selected_by_player:
				toggle_factory_select()
		else:
			SFXPlayer.play_failed_action()
	elif factory_type == GlobalVariables.FACTORY_TYPE.CRATE:
		if (
			type == GlobalVariables.RESOURCE_TYPE.WOOD
			and type not in resources_invested
		):
			left_input_sprite.modulate.a = 255
			left_input_sprite.material = highlighted_material
			resources_invested.append(GlobalVariables.RESOURCE_TYPE.WOOD)
			
			if selected_by_player:
				toggle_factory_select()
		elif (
			type == GlobalVariables.RESOURCE_TYPE.METAL
			and type not in resources_invested
		):
			right_input_sprite.modulate.a = 255
			right_input_sprite.material = highlighted_material
			resources_invested.append(GlobalVariables.RESOURCE_TYPE.METAL)
			
			if selected_by_player:
				toggle_factory_select()
		else:
			SFXPlayer.play_failed_action()
	elif factory_type == GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER:
		if (
			type == GlobalVariables.RESOURCE_TYPE.PLANK
			and type not in resources_invested
		):
			left_input_sprite.modulate.a = 255
			left_input_sprite.material = highlighted_material
			resources_invested.append(GlobalVariables.RESOURCE_TYPE.PLANK)
			
			if selected_by_player:
				toggle_factory_select()
		elif (
			type == GlobalVariables.RESOURCE_TYPE.INGOT
			and type not in resources_invested
		):
			right_input_sprite.modulate.a = 255
			right_input_sprite.material = highlighted_material
			resources_invested.append(GlobalVariables.RESOURCE_TYPE.INGOT)
			
			if selected_by_player:
				toggle_factory_select()
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
		if accepting_inputs or has_output:
			toggle_factory_select()
		else:
			# Do not allow selection while factory in process
			SFXPlayer.play_failed_action()

func run_factory(delta):
	# Ensure that all correct inputs exist, then continue processing
	var inputs_satisfied: bool = false
	
	if (
		factory_type == GlobalVariables.FACTORY_TYPE.PLANK
		and GlobalVariables.RESOURCE_TYPE.WOOD in resources_invested
	):
		inputs_satisfied = true
	elif (
		factory_type == GlobalVariables.FACTORY_TYPE.INGOT
		and GlobalVariables.RESOURCE_TYPE.METAL in resources_invested
	):
		inputs_satisfied = true
	elif (
		factory_type == GlobalVariables.FACTORY_TYPE.CRATE
		and GlobalVariables.RESOURCE_TYPE.WOOD in resources_invested
		and GlobalVariables.RESOURCE_TYPE.METAL in resources_invested
	):
		inputs_satisfied = true
	elif (
		factory_type == GlobalVariables.FACTORY_TYPE.SHIPPING_CONTAINER
		and GlobalVariables.RESOURCE_TYPE.PLANK in resources_invested
		and GlobalVariables.RESOURCE_TYPE.INGOT in resources_invested
	):
		inputs_satisfied = true
	
	if inputs_satisfied:
		# All inputs received: if processing has begun, deselect the factory
		if selected_by_player:
			toggle_factory_select()
		
		# Do not accept new inputs
		accepting_inputs = false
		
		# Progress the factory dependent on time (not frames)
		processing_percentage += PROCESSING_STEP * delta
		
		# If process completed, clean up factory and present output
		if processing_percentage >= 100:
			# Ready! Pass the created resource into the completion method
			complete_output_resource(output_resource)

func complete_output_resource(type: GlobalVariables.RESOURCE_TYPE):
	# Set the output resource
	has_output = true
	
	# Maximum opacity on output resource
	output_sprite.modulate.a = 255
	
	# Highlight output resource
	output_sprite.material = highlighted_material
	
	# Clear the resources_invested
	resources_invested = []
	
	# Turn off smoke
	smoke_animation.visible = false
	
	# Reduce opacity on input icons
	single_input_sprite.modulate.a = 128
	left_input_sprite.modulate.a = 128
	right_input_sprite.modulate.a = 128
	
	# Remove highlights on input icons
	single_input_sprite.material = null
	left_input_sprite.material = null
	right_input_sprite.material = null
	
	SFXPlayer.play_factory_complete()

func _process(delta):
	# Process the factory each frame
	run_factory(delta)
	progress_bar.value = processing_percentage
	
	if progress_bar.value > 0 and progress_bar.value < 100:
		smoke_animation.visible = true
