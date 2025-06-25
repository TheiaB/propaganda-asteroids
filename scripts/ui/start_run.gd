extends Node2D
@onready var button: Button = $Button

signal start_run

func _ready():
	button.pressed.connect(_button_pressed)

func _button_pressed():
	emit_signal("start_run")
