extends AudioStreamPlayer2D

var muted: bool = false

@onready var audio_menu_track = preload("res://Sounds/Menu_Music.wav")
@onready var audio_bg_track = preload("res://Sounds/ClockWork (BG music).mp3")
@onready var audio_test = preload("res://Sounds/Factory Complete.wav")

func _ready():
	connect('finished', Callable(self, '_on_finished'))

func _on_finished():
	play_background_music()

func play_menu_music():
	stream = audio_menu_track
	play()

func play_background_music():
	stream = audio_bg_track
	play()

func stop_background_music():
	stop()

func toggle_mute():
	if muted:
		muted = false
		volume_db = 0
	elif !muted:
		muted = true
		volume_db = -1000
