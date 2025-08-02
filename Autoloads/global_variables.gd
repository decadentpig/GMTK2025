extends Node

# RESOURCE SPRITES
@onready var wood_sprite = preload("res://Assets/Icon-Wood.png")
@onready var metal_sprite = preload("res://Assets/Icon-Rock.png")
@onready var plank_sprite = preload("res://Assets/Icon-Planks.png")
@onready var ingot_sprite = preload("res://Assets/Icon_Ingot.png")
@onready var crate_sprite = preload("res://Assets/Icon-Crate.png")
@onready var shipping_container_sprite = preload("res://Assets/Icon-ShippingContainer.png")

# MUSIC / SFX
@onready var audio_bg_track = preload("res://Sounds/ClockWork (BG music).mp3")
@onready var audio_contract_complete = preload("res://Sounds/Drop Off Contract.wav")
@onready var audio_factory_complete = preload("res://Sounds/Factory Complete.wav")
@onready var audio_failed_action = preload("res://Sounds/Failed : Not Allowed.wav")
@onready var audio_make_selection = preload("res://Sounds/Make Selection.wav")
@onready var audio_pickup_resource = preload("res://Sounds/Pickup Resources.wav")
@onready var audio_start_factory = preload("res://Sounds/Start Factory.wav")

var tutorial_on: bool = true
enum RESOURCE_TYPE {NONE, WOOD, METAL}
