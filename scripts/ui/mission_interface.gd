extends TabBar

class_name MissionInterface

signal open_mission_button

func on_button_click(mission: Mission):
	emit_signal("open_mission_button", mission)

func get_button(mission):
	var button = Button.new()
	button.text = mission.title
	button.pressed.connect(on_button_click.bind(mission))
	return button

func set_displayed_mission(missions: Array[Mission]):
	for child in get_children():
		if child is VBoxContainer:
			remove_child(child)

	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(PRESET_CENTER)
	var reversed_list = missions.duplicate()
	reversed_list.reverse()
	for mission in reversed_list:
		vbox.add_child(get_button(mission))
	add_child(vbox)
	vbox.position -= vbox.size / 2
