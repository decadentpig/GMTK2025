extends PathFollow2D

const SPEED = 3
const DEFAULT_CARRIAGES = 3
const OFFSET = 125

@onready var path2d = get_parent()
@onready var carriage_prefab = preload("res://Scenes/carriage_prefab.tscn")

var num_carriages = 0

func create_carriage() -> void:
	var carriage = carriage_prefab.instantiate()
	path2d.add_child.call_deferred(carriage)
	carriage.speed = SPEED
	carriage.progress = (progress - 15) - (OFFSET * (num_carriages+1))
	carriage.request_carriage_add.connect(_on_request_carriage_add)
	num_carriages += 1
	Stats.num_carriages += 1

func _ready() -> void:
	progress = 100 * DEFAULT_CARRIAGES
	for n in DEFAULT_CARRIAGES:
		create_carriage()

func _process(delta: float) -> void:
	progress += SPEED

func _on_request_carriage_add():
	create_carriage()
