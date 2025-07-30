extends Node2D

var speed = 10

func _process(delta):
	if Input.is_action_pressed('Move_Up'):
		position.y -= speed
	
	if Input.is_action_pressed('Move_Down'):
		position.y += speed
	
	if Input.is_action_pressed('Move_Left'):
		position.x -= speed
	
	if Input.is_action_pressed('Move_Right'):
		position.x += speed
