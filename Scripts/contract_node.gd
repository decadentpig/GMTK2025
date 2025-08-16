extends StaticBody2D
class_name Contract_Node

var contract_money: int = 0

var clicked_at = -1

var selected_by_player: bool = false
var contract_type: GlobalVariables.RESOURCE_TYPE = GlobalVariables.RESOURCE_TYPE.NONE

@onready var failed_contract_bubble = preload("res://Assets/Customer-Speechbox-Failed.png")

@onready var sprite2d = get_node("Sprite2D")
@onready var resource_sprite = get_node("Resource_Sprite")
@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")
@onready var contract_value = get_node("Contract_Value")

var game_manager: Game_Manager = null

func initialise(game_manager: Game_Manager):
	self.game_manager = game_manager

func _process(delta: float) -> void:
	contract_money = game_manager.contract_money[contract_type][game_manager.current_phase]

	contract_value.text = '($' + str(contract_money) + ')'

func trigger_contract_failed() -> void:
	# 1. Show red bubble
	sprite2d.texture = failed_contract_bubble
	
	# 2. Set a timer
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	self.queue_free()

func set_contract_type(type: GlobalVariables.RESOURCE_TYPE):
	contract_type = type
	resource_sprite.texture = GlobalVariables.resource_sprite_map[type]

func toggle_player_select():
	if selected_by_player:
		selected_by_player = false
		SFXPlayer.play_make_selection()
		sprite2d.material = null

		# Reset timer
		clicked_at = -1
	elif !selected_by_player:
		selected_by_player = true
		SFXPlayer.play_make_selection()
		sprite2d.material = highlighted_material

		# Start timer since selection was made
		clicked_at = Time.get_ticks_msec()

func get_lifetime_ms():
	return Time.get_ticks_msec() - clicked_at

func complete_contract() -> void:
	SFXPlayer.play_audio_earned_money()
	Stats.money += contract_money
	Stats.contracts_complete += 1
	
	var str = '+ $' + str(contract_money)
	var x = position.x - 64
	var y = position.y - 64
	game_manager.create_floating_text(Vector2(x,y), str, Color.GREEN, 120)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		toggle_player_select()
