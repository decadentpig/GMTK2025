extends Node2D

@onready var house1 = preload("res://Assets/House1.png")
@onready var house2 = preload("res://Assets/House2.png")
@onready var house3 = preload("res://Assets/House3.png")
@onready var house4 = preload("res://Assets/House4.png")
@onready var house5 = preload("res://Assets/House5.png")
@onready var house6 = preload("res://Assets/House6.png")

func _on_ready() -> void:
	var sprites = [house1, house2, house3, house4, house5, house6]
	
	for child in get_children():
		var rand = randi_range(0, 5)
		
		child.texture = sprites[rand]
