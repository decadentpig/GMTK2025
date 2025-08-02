extends AudioStreamPlayer2D

@onready var audio_bg_track = preload("res://Sounds/ClockWork (BG music).mp3")
@onready var audio_test = preload("res://Sounds/Factory Complete.wav")

func _ready():
	connect('finished', Callable(self, '_on_finished'))

func _on_finished():
	play_background_music()

func play_background_music():
	stream = audio_bg_track
	play()

func stop_background_music():
	stop()
