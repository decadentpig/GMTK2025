extends Node2D

var text: String = '(ERROR)'
var color: Color = Color.WHITE
var total_frames = 1000
var frames_remaining = 1000 # Set to true value later

var speed = 0.3

@onready var label = get_node("Label")

func setup_floating_text(pos:Vector2, text: String, color: Color, frames: int):
		label.text = text
		label.add_theme_color_override("font_color", color)
		self.total_frames = frames
		self.frames_remaining = frames
		position = pos

func _process(delta):
	frames_remaining -= 1
	
	if frames_remaining > 0:
		position.y -= speed
		label.self_modulate.a -= 0.001
	else:
		queue_free()
