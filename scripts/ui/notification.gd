extends Node2D

class_name Notification
@onready var rich_text_label: RichTextLabel = $RichTextLabel

func notify(text: String, time:float):
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.timeout.connect(rich_text_label.hide)
	timer.start()
	rich_text_label.text = text
	rich_text_label.show()
