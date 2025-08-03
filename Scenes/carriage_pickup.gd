extends StaticBody2D
class_name Carriage_Pickup_Node

@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")
@onready var sprite2d = get_node("Sprite2D")
@onready var cost_label = get_node("Cost")

var cost = 30
var selected_by_player: bool = false

func toggle_player_select():
	if selected_by_player:
		selected_by_player = false
		SFXPlayer.play_make_selection()
		sprite2d.material = null
	elif !selected_by_player:
		selected_by_player = true
		SFXPlayer.play_make_selection()
		sprite2d.material = highlighted_material

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		toggle_player_select()

func _ready() -> void:
	cost_label.text = str(cost)
