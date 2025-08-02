extends Node

# RESOURCE SPRITES
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")
@onready var plank_sprite = preload("res://Assets/Icon-Planks.png")
@onready var ingot_sprite = preload("res://Assets/Icon_Ingot.png")
@onready var crate_sprite = preload("res://Assets/Icon-Crate.png")
@onready var shipping_container_sprite = preload("res://Assets/Icon-ShippingContainer.png")

var tutorial_on: bool = true
enum RESOURCE_TYPE {NONE, WOOD, METAL}
