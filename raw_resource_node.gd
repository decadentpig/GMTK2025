extends Node2D

class_name Raw_Resource

enum Resource_Type {NONE, WOOD, METAL}
var resource_type: Resource_Type = Resource_Type.NONE

var selected_by_player: bool = false

@onready var sprite2d = get_node("Sprite2D")
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")

@onready var highlight_material = preload("res://Scenes/resource_highlight_material.material")

func set_resource_type(type: String):
	if type == "WOOD":
		resource_type = Resource_Type.WOOD
		sprite2d.texture = wood_sprite
	elif type == "METAL":
		resource_type = Resource_Type.METAL
		sprite2d.texture = metal_sprite
	else:
		print_debug("Whoops! Tried to set a raw resource to an invalid type!")

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
	if Input.is_action_just_pressed("Click"):
		toggle_player_select()
