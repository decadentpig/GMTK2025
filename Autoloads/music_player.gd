extends AudioStreamPlayer2D

@onready var audio_bg_track = preload("res://Sounds/ClockWork (BG music).mp3")

func play_background_music():
	stream = audio_bg_track
	play()
