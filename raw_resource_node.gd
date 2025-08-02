extends Node2D

class_name Raw_Resource

var resource_type = GlobalVariables.RESOURCE_TYPE.NONE
var selected_by_player: bool = false

@onready var sprite2d = get_node("Sprite2D")
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")

@onready var highlight_material = preload("res://Scenes/resource_highlight_material.material")

func set_resource_type(type: GlobalVariables.RESOURCE_TYPE):
	resource_type = type
	if type == GlobalVariables.RESOURCE_TYPE.WOOD:
		sprite2d.texture = wood_sprite
	elif type == GlobalVariables.RESOURCE_TYPE.METAL:
		sprite2d.texture = metal_sprite
	else:
		print_debug("Whoops! Tried to set a raw resource to an invalid type!", type)

func toggle_player_select():
	if !selected_by_player:
		selected_by_player = true
		sprite2d.material = highlight_material
		print("Switched resource to selected!")
	elif selected_by_player:
		selected_by_player = false
		sprite2d.material = null
		print("Switched resource to unselected!")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("Click"):
		print("Clicking")
		toggle_player_select()
