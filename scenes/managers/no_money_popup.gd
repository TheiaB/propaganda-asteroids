extends PopupPanel

@onready var label : Label = $Label
@onready var color_rect = $ColorRect
@onready var close_timer = $CloseTimer

var blink_timer := 0.0
var blink_speed := 8.0

func show_popup():
	label.text = "You don't have enough money to buy this. \nMaybe try working some more."
	label.add_theme_font_size_override("font_size", 36)
	color_rect.set_color(Color(1, 0, 0))
	close_timer.start()
	show()
	popup_centered()
	
func _process(delta):
	blink_timer += delta * blink_speed
	var intensity = abs(sin(blink_timer))
	color_rect.set_color(Color(lerp(0.5, 1.0, intensity),0,0))

	var shake_amount = 5.0
	var shake_position = Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)
	label.position = shake_position

func _on_close_timer_timeout() -> void:
	hide()
