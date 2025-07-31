extends PathFollow2D

const SPEED = 1

@onready var path2d = get_parent()
@onready var carriage_prefab = preload("res://Scenes/carriage_prefab.tscn")

func _ready() -> void:
	var carriages = 3
	progress = 100 * carriages
	for n in range(1, carriages):
		var carriage = carriage_prefab.instantiate()
		path2d.add_child.call_deferred(carriage)
		carriage.speed = SPEED
		carriage.progress = progress - (100 * n)

func _process(delta: float) -> void:
	progress += SPEED
