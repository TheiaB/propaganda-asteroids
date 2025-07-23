@tool
extends Panel
class_name ItemPanel

@export var title:String
@export var price:int
@export var description:String
@export var presentation_video : VideoStream

@onready var label_title: Label = $VBoxContainer/MarginContainer/HBoxContainer/LabelTitle
@onready var label_price: Label = $VBoxContainer/MarginContainer/HBoxContainer/LabelPrice
@onready var video_stream_player: VideoStreamPlayer = $VBoxContainer/VideoStreamPlayer

signal buy_button_pressed

func _ready() -> void:
	update_item()

func update_item():
	if(presentation_video != null):
		video_stream_player.stream = presentation_video
		video_stream_player.play()
	if(title != null):
		label_title.text = title
	if(price != null):
		label_price.text = "		" + str(price) + " $"
	

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		pass


func _on_gui_input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT and _event.is_pressed():
		_on_buy_button_pressed()
	elif _event.is_action_pressed("click"):
		_on_buy_button_pressed()


func _on_buy_button_pressed() -> void:
	emit_signal("buy_button_pressed")

func _get_tooltip(_at_position: Vector2):
	return "%s" % [description]
