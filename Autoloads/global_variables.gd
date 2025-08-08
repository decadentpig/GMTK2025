extends Node

# RESOURCE SPRITES
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")
@onready var plank_sprite = preload("res://Assets/Icon-Planks.png")
@onready var ingot_sprite = preload("res://Assets/Icon_Ingot.png")
@onready var crate_sprite = preload("res://Assets/Icon-Crate.png")
@onready var shipping_container_sprite = preload("res://Assets/Icon-ShippingContainer.png")

var tutorial_on: bool = true
enum RESOURCE_TYPE {NONE, WOOD, METAL, PLANK, INGOT, CRATE, SHIPPING_CONTAINER}
enum FACTORY_TYPE {NONE, PLANK, INGOT, CRATE, SHIPPING_CONTAINER}
const MAX_CARRIAGE_PICKUPS = 1

@onready var resource_sprite_map = {
	RESOURCE_TYPE.WOOD: preload("res://Assets/Icon-Wood.png"),
	RESOURCE_TYPE.METAL: preload("res://Assets/Icon-Rock.png"),
	RESOURCE_TYPE.PLANK: preload("res://Assets/Icon-Planks.png"),
	RESOURCE_TYPE.INGOT: preload("res://Assets/Icon_Ingot.png"),
	RESOURCE_TYPE.CRATE: preload("res://Assets/Icon-Crate.png"),
	RESOURCE_TYPE.SHIPPING_CONTAINER: preload("res://Assets/Icon-ShippingContainer.png")
}
