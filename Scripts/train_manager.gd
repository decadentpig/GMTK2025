extends PathFollow2D

const SPEED = 3
const DEFAULT_CARRIAGES = 10
const OFFSET = 125

@onready var path2d = get_parent()
@onready var carriage_prefab = preload("res://Scenes/carriage_prefab.tscn")

func _ready() -> void:
	progress = 100 * DEFAULT_CARRIAGES
	for n in DEFAULT_CARRIAGES:
		var carriage = carriage_prefab.instantiate()
		path2d.add_child.call_deferred(carriage)
		carriage.speed = SPEED
		carriage.progress = progress - (OFFSET * (n+1))

func _process(delta: float) -> void:
	progress += SPEED
