extends CanvasLayer

class_name Notification
@onready var texture_rect : TextureRect = $MarginContainer/TextureRect
@onready var button: Button = $Button


func _ready() -> void:
	button.pressed.connect(self.hide)
