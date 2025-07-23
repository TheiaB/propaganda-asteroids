extends PanelContainer

class_name MissionPopup

var current_mission : Mission
var is_finish: bool

signal on_mission_popup_button_pressed
signal on_finish_mission_popup_button_pressed

@onready var mission_title: Label = $ScrollContainer/VBoxContainer/Title
@onready var rich_text_label: RichTextLabel = $ScrollContainer/VBoxContainer/RichTextLabel
@onready var button: Button = $ScrollContainer/VBoxContainer/Button




func popup_mission(mission: Mission):
	current_mission = mission
	mission_title.text = mission.title
	rich_text_label.text = mission.text
	button.text = "I want to start this Mission"
	is_finish = false
	self.show_centered()

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
	self.show_centered()
	

func show_centered():
	# Ensure the panel is visible
	visible = true

	# Get the size of the viewport and the panel
	var viewport_size = get_viewport().get_visible_rect().size
	var panel_size = self.size

	# Position the panel at the center of the viewport
	self.position = (viewport_size - panel_size) / 2
