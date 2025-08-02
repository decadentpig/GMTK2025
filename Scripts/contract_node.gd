extends RigidBody2D
class_name Contract_Node
signal request_money_update(amount)

const CONTRACT_MONEY = 5
var selected_by_player: bool = false
var contract_type: GlobalVariables.RESOURCE_TYPE = GlobalVariables.RESOURCE_TYPE.NONE

@onready var sprite2d = get_node("Sprite2D")
@onready var resource_sprite = get_node("Resource_Sprite")
@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")

func set_contract_type(type: GlobalVariables.RESOURCE_TYPE):
	contract_type = type
	if contract_type == GlobalVariables.RESOURCE_TYPE.WOOD:
		resource_sprite.texture = wood_sprite
	elif contract_type == GlobalVariables.RESOURCE_TYPE.METAL:
		resource_sprite.texture = metal_sprite
	else:
		print("Have only implemented wood and metal sprites on contract nodes! Whoops")

func toggle_player_select():
	if selected_by_player:
		selected_by_player = false
		SFXPlayer.play_make_selection()
		sprite2d.material = null
	elif !selected_by_player:
		selected_by_player = true
		SFXPlayer.play_make_selection()
		sprite2d.material = highlighted_material
		
		
func complete_contract() -> void:
	SFXPlayer.play_contract_complete()
	emit_signal("request_money_update", 5)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		toggle_player_select()
