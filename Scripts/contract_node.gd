extends RigidBody2D
class_name Contract_Node

var contract_money: int = 0

const WOOD_MONEY = 5
const METAL_MONEY = 5
const PLANK_MONEY = 15
const INGOT_MONEY = 15
const CRATE_MONEY = 25
const SHIPPING_CONTAINER_MONEY = 50

var selected_by_player: bool = false
var contract_type: GlobalVariables.RESOURCE_TYPE = GlobalVariables.RESOURCE_TYPE.NONE

@onready var sprite2d = get_node("Sprite2D")
@onready var resource_sprite = get_node("Resource_Sprite")
@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")

var game_manager: Game_Manager = null

func initialise(game_manager: Game_Manager):
	self.game_manager = game_manager

func set_contract_type(type: GlobalVariables.RESOURCE_TYPE):
	contract_type = type
	if contract_type == GlobalVariables.RESOURCE_TYPE.WOOD:
		resource_sprite.texture = GlobalVariables.wood_sprite
		contract_money = WOOD_MONEY
	elif contract_type == GlobalVariables.RESOURCE_TYPE.METAL:
		resource_sprite.texture = GlobalVariables.metal_sprite
		contract_money = METAL_MONEY
	elif contract_type == GlobalVariables.RESOURCE_TYPE.PLANK:
		resource_sprite.texture = GlobalVariables.plank_sprite
		contract_money = PLANK_MONEY
	elif contract_type == GlobalVariables.RESOURCE_TYPE.INGOT:
		resource_sprite.texture = GlobalVariables.ingot_sprite
		contract_money = INGOT_MONEY
	elif contract_type == GlobalVariables.RESOURCE_TYPE.CRATE:
		resource_sprite.texture = GlobalVariables.crate_sprite
		contract_money = CRATE_MONEY
	elif contract_type == GlobalVariables.RESOURCE_TYPE.SHIPPING_CONTAINER:
		resource_sprite.texture = GlobalVariables.shipping_container_sprite
		contract_money = SHIPPING_CONTAINER_MONEY
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
	Stats.money += contract_money
	Stats.contracts_complete += 1
	
	var str = '+ $' + str(contract_money)
	var x = position.x - 64
	var y = position.y - 64
	game_manager.create_floating_text(Vector2(x,y), str, Color.GREEN, 120)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		toggle_player_select()
