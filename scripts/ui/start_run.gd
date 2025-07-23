extends Node2D
@onready var button: Button = $Button

signal start_run

func _ready():
	button.pressed.connect(_button_pressed)
	

func _button_pressed():
	SoundManager5000.basic_button_sfx.play_one_shot()
	emit_signal("start_run")
	
