extends CanvasLayer

class_name Notification
@onready var texture_rect : TextureRect = $MarginContainer/TextureRect


func notify(time:float):
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.timeout.connect(self.hide)
	timer.start()
