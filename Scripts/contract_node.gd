extends RigidBody2D
class_name Contract_Node

var selected_by_player: bool = false

@onready var sprite2d = get_node("Sprite2D")

@onready var highlighted_material = preload("res://Scenes/resource_highlight_material.material")

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
