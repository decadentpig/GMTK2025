extends PathFollow2D

enum Cargo {EMPTY, WOOD, METAL}
var speed = 0
var cargo: Cargo = Cargo.EMPTY

func _ready() -> void:
	print_debug("Carriage Progress", progress)

func _process(delta: float) -> void:
	progress += speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Selected by player?", body.selected_by_player)
