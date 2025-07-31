extends Node2D

enum Resource_Type {NONE, WOOD, METAL}
var resource_type: Resource_Type = Resource_Type.NONE

var selected_by_player: bool = false

@onready var sprite2d = get_node("Sprite2D")
@onready var wood_sprite = preload("res://Assets/placeholder_wood.png")
@onready var metal_sprite = preload("res://Assets/placeholder_metal.png")

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
		# TODO: Change the sprite to show selected state?
	elif selected_by_player:
		selected_by_player = false
		# TODO: Change the sprite to show deselected state?
		

# Listen for player click events to toggle schedule / unschedule
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		toggle_player_select()
