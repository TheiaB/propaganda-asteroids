extends PopupPanel

var current_mission : Mission

signal on_mission_popup_button_pressed

@onready var mission_title: Label = $VBoxContainer/Title
@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel


func popup_mission(mission: Mission):
	current_mission = mission
	mission_title.text = mission.title
	rich_text_label.text = mission.text
	self.popup_centered()

func _on_button_pressed() -> void:
	emit_signal("on_mission_popup_button_pressed", current_mission)
