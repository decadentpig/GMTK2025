extends PathFollow2D
signal request_carriage_add()

var speed = 0
var cargo = GlobalVariables.RESOURCE_TYPE.NONE

@onready var sprite = get_node("AnimatedSprite2D")
@onready var sprite2d = get_node("Sprite2D")

func _physics_process(delta: float) -> void:
	sprite.play("default")
	progress += speed * delta

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
		SFXPlayer.play_contract_complete()
		cargo = GlobalVariables.RESOURCE_TYPE.NONE
		sprite2d.texture = null
		body.complete_contract()
	elif (
		body is Contract_Node
		and body.selected_by_player
		and cargo != body.contract_type
	):
		SFXPlayer.play_failed_action()
		
	# Buy carriages
	if (
		body is Carriage_Pickup_Node
		and body.selected_by_player
		and Stats.money >= body.cost
	):
		body.queue_free()
		SFXPlayer.play_pickup_resource()
		Stats.money -= body.cost
		Stats.available_carriages -= 1
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
