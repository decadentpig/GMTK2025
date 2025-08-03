extends AudioStreamPlayer2D

@onready var audio_contract_complete = preload("res://Sounds/Drop Off Contract.wav")
@onready var audio_factory_complete = preload("res://Sounds/Factory Complete.wav")
@onready var audio_failed_action = preload("res://Sounds/Failed Not Allowed.wav")
@onready var audio_make_selection = preload("res://Sounds/Make Selection.wav")
@onready var audio_pickup_resource = preload("res://Sounds/Pickup Resources.wav")
@onready var audio_start_factory = preload("res://Sounds/Start Factory.wav")

@onready var audio_earned_money = preload("res://Sounds/Contract_Sound.wav")
@onready var audio_lost_money = preload("res://Sounds/Tax_Sound.wav")

func play_audio_earned_money():
	stream = audio_earned_money
	play()

func play_audio_lost_money():
	stream = audio_lost_money
	play()

func play_contract_complete():
	stream = audio_contract_complete
	play()

func play_factory_complete():
	stream = audio_factory_complete
	play()

func play_failed_action():
	stream = audio_failed_action
	play()

func play_make_selection():
	stream = audio_make_selection
	play()

func play_pickup_resource():
	stream = audio_pickup_resource
	play()

func play_start_factory():
	stream = audio_start_factory
	play()
