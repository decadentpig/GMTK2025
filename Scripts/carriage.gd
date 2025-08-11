extends PathFollow2D
signal request_carriage_add()

var carriage_index: int = -1

var speed = 0
var cargo = GlobalVariables.RESOURCE_TYPE.NONE

var last_position = Vector2.ZERO

var train_manager: Train_Manager = null

@onready var sprite = get_node("AnimatedSprite2D")
@onready var sprite2d = get_node("Sprite2D")

func _ready():
	last_position = position

func initialise(instance: Train_Manager, carriage_index):
	self.train_manager = instance
	self.carriage_index = carriage_index

func _physics_process(delta: float) -> void:
	sprite.play("default")
	progress += speed * delta
	
	var movement = position - last_position
	
	# Check horizontal/vertical movement
	if abs(movement.x) > abs(movement.y):
		if movement.x > 0:
			# TODO: Set sprite to normal rotation
			sprite2d.rotation_degrees = 0
		elif movement.x < 0:
			# TODO: Set sprite to 180 rotation
			sprite2d.rotation_degrees = 180
	else:
		if movement.y > 0:
			# TODO: Set sprite to 90 rotation
			sprite2d.rotation_degrees = 270
		elif movement.y < 0:
			# TODO: Set sprite to 270 rotation
			sprite2d.rotation_degrees = 90

	last_position = global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Pickup resources
	if (
		body is Raw_Resource
		and body.selected_by_player
		and cargo == GlobalVariables.RESOURCE_TYPE.NONE
	):
		body.queue_free()
		SFXPlayer.play_pickup_resource()
		cargo = body.resource_type
		if cargo == GlobalVariables.RESOURCE_TYPE.WOOD:
			sprite2d.texture = GlobalVariables.wood_sprite
		elif cargo == GlobalVariables.RESOURCE_TYPE.METAL:
			sprite2d.texture = GlobalVariables.metal_sprite
		else:
			print("ERROR. UNEXPECTED CARGO", cargo)
	elif (
		body is Raw_Resource
		and body.selected_by_player
		and cargo != GlobalVariables.RESOURCE_TYPE.NONE
	):
		SFXPlayer.play_failed_action()

		
	# Complete contracts
	if (
		body is Contract_Node
		and body.selected_by_player
		and cargo == body.contract_type
	):
		body.queue_free()
		SFXPlayer.play_audio_earned_money()
		cargo = GlobalVariables.RESOURCE_TYPE.NONE
		sprite2d.texture = null
		body.complete_contract()
		
	# Buy carriages
	if (
		body is Carriage_Pickup_Node
		and body.selected_by_player
		and Stats.money >= body.cost
	):
		body.queue_free()
		SFXPlayer.play_audio_lost_money()
		Stats.money -= body.cost
		emit_signal("request_carriage_add")
	elif (
		body is Carriage_Pickup_Node
		and body.selected_by_player
		and Stats.money < body.cost
	):
		SFXPlayer.play_failed_action()
	
	if (
		body is Factory_Node
		and body.selected_by_player
	):
		# Drop-off resources to factory
		if (
			body.accepting_inputs 
			and cargo in body.resources_accepted 
			and cargo not in body.resources_invested
		):
			body.insert_resource(cargo)
			cargo = GlobalVariables.RESOURCE_TYPE.NONE
			sprite2d.texture = null
		# Pickup resources from factory
		elif body.has_output and cargo == GlobalVariables.RESOURCE_TYPE.NONE:
			cargo = body.output_resource
			
			# Reset the factory now that output resource has been collected
			body.set_factory_type(body.factory_type)
			
			# Set resource sprite in carriage
			if cargo == GlobalVariables.RESOURCE_TYPE.WOOD:
				sprite2d.texture = GlobalVariables.wood_sprite
			elif cargo == GlobalVariables.RESOURCE_TYPE.METAL:
				sprite2d.texture = GlobalVariables.metal_sprite
			elif cargo == GlobalVariables.RESOURCE_TYPE.PLANK:
				sprite2d.texture = GlobalVariables.plank_sprite
			elif cargo == GlobalVariables.RESOURCE_TYPE.INGOT:
				sprite2d.texture = GlobalVariables.ingot_sprite
			elif cargo == GlobalVariables.RESOURCE_TYPE.CRATE:
				sprite2d.texture = GlobalVariables.crate_sprite
			elif cargo == GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER:
				sprite2d.texture = GlobalVariables.shipping_container_sprite
				
			if body.selected_by_player:
				body.toggle_factory_select()

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Detect contracts leaving the collision box of the last carriage
	# If the contract is unfulfilled, the contract fails
	
	if (
		body is Contract_Node
		and body.selected_by_player
		and train_manager.is_last_carriage(carriage_index)
		and cargo != body.contract_type
		and body.get_lifetime_ms() > 500
	):
		print("Lifetime was " + str(body.get_lifetime_ms()))
		body.queue_free()
		SFXPlayer.play_failed_action()
