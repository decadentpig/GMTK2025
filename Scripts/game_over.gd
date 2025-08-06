extends Node2D

@onready var new_game_button = get_node("New_Game_Button")
@onready var loops_label = get_node("Loops_Label")

func _ready():
	MusicPlayer.play_menu_music()
	loops_label.text = "Loops: " + str(Stats.previous_game_loops)

func _on_new_game_button_pressed() -> void:
	GlobalVariables.tutorial_on = true
	Stats.apply_defaults()
	get_tree().change_scene_to_file("res://Levels/scene.tscn")
