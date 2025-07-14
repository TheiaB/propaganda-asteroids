extends PopupPanel

class_name MissionPopup

var current_mission : Mission
var is_finish: bool

signal on_mission_popup_button_pressed
signal on_finish_mission_popup_button_pressed

@onready var mission_title: Label = $VBoxContainer/Title
@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var button: Button = $VBoxContainer/Button

func popup_mission(mission: Mission):
	current_mission = mission
	mission_title.text = mission.title
	rich_text_label.text = mission.text
	button.text = "I want to start this Mission"
	is_finish = false
	self.popup_centered()

func _on_button_pressed() -> void:
	if is_finish:
		emit_signal("on_finish_mission_popup_button_pressed", current_mission)
	else:
		emit_signal("on_mission_popup_button_pressed", current_mission)
		

	
func popup_mission_finish(mission: Mission):
	current_mission = mission
	mission_title.text = mission.title
	rich_text_label.text = mission.text
	button.text = "I want to finish this mission"
	is_finish = true
	self.popup_centered()
