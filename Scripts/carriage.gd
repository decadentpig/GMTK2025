extends PathFollow2D

enum Cargo {EMPTY, WOOD, METAL}
var speed = 0
var cargo: Cargo = Cargo.EMPTY

@onready var sprite = get_node("AnimatedSprite2D")

func _ready() -> void:
	print_debug("Carriage Progress", progress)

func _process(delta: float) -> void:
	sprite.play("default")
	progress += speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (
		body is Raw_Resource
		and body.selected_by_player
		and cargo == Cargo.EMPTY
	):
		body.queue_free()
	else:
		print("Collided with", body.name, body.selected_by_player, cargo)
