extends PathFollow2D
signal request_carriage_add()

var speed = 0
var cargo = GlobalVariables.RESOURCE_TYPE.NONE

@onready var sprite = get_node("AnimatedSprite2D")
@onready var sprite2d = get_node("Sprite2D")
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")

func _ready() -> void:
	print_debug("Carriage Progress", progress)

func _process(delta: float) -> void:
	sprite.play("default")
	progress += speed
	
	

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
			sprite2d.texture = wood_sprite
		elif cargo == GlobalVariables.RESOURCE_TYPE.METAL:
			sprite2d.texture = metal_sprite
		else:
			print("ERROR. UNEXPECTED CARGO", cargo)

		
	# Complete contracts
	if (
		body is Contract_Node
		and body.selected_by_player
		and cargo == body.contract_type
	):
		body.queue_free()
		cargo = GlobalVariables.RESOURCE_TYPE.NONE
		sprite2d.texture = null
		body.complete_contract()
		
	# Buy carriages
	if (
		body is Carriage_Pickup_Node
		and body.selected_by_player
		and Stats.money > 50
	):
		body.queue_free()
		Stats.money -= 50
		emit_signal("request_carriage_add")
		
		
