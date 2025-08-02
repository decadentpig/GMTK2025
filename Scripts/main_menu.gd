extends Node2D

@onready var new_game_button = get_node("New_Game_Button")
@onready var challenge_mode_button = get_node("Challenge_Mode_Button")

func _ready():
	MusicPlayer.play_menu_music()

func _on_new_game_button_pressed() -> void:
	GlobalVariables.tutorial_on = true
	get_tree().change_scene_to_file("res://scene.tscn")

func _on_challenge_mode_button_pressed() -> void:
	GlobalVariables.tutorial_on = false
	get_tree().change_scene_to_file("res://scene.tscn")
