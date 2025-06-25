extends Node2D
@onready var button: Button = $Button

signal next_run

func _ready():
	button.pressed.connect(_button_pressed)

func _button_pressed():
	emit_signal("next_run")
