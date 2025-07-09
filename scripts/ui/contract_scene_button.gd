extends Node2D
@onready var button: Button = $Button

signal accept_contract

func _ready():
	button.pressed.connect(_button_pressed)

func _button_pressed():
	emit_signal("accept_contract")
