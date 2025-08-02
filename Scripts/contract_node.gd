extends RigidBody2D
class_name Contract_Node

var selected_by_player: bool = false
var contract_type: GlobalVariables.RESOURCE_TYPE = GlobalVariables.RESOURCE_TYPE.NONE

@onready var sprite2d = get_node("Sprite2D")
@onready var resource_sprite = get_node("Resource_Sprite")
@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")

func set_contract_type(type: GlobalVariables.RESOURCE_TYPE):
	contract_type = type
	if contract_type == GlobalVariables.RESOURCE_TYPE.WOOD:
		resource_sprite.texture = GlobalVariables.wood_sprite
	elif contract_type == GlobalVariables.RESOURCE_TYPE.METAL:
		resource_sprite.texture = GlobalVariables.RESOURCE_TYPE.METAL
	else:
		print("Have only implemented wood and metal sprites on contract nodes! Whoops")

func toggle_player_select():
	if selected_by_player:
		selected_by_player = false
		sprite2d.material = null
	elif !selected_by_player:
		selected_by_player = true
		sprite2d.material = highlighted_material

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		toggle_player_select()
