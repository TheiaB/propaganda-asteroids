extends Node2D
@onready var button: Button = $Button

signal next_run

func _ready():
	button.pressed.connect(_button_pressed)

func _button_pressed():
	SoundManager5000.basic_button_sfx.play_one_shot()
	emit_signal("next_run")
