extends VBoxContainer

@onready var bus = FmodServer.get_bus("bus:/")
@onready var volume_slider : HSlider = $VolumeSlider
@onready var spin_box = $HBoxContainer/SpinBox

func _ready() -> void:
	var saved_volume = ProjectSettings.get_setting("user/master_volume", 1.0)
	volume_slider.value = saved_volume
	bus.set_volume(saved_volume)
	spin_box.value = saved_volume


func _on_spin_box_value_changed(value: float) -> void:
	if bus:
		volume_slider.value = value  # keep slider in sync
		bus.set_volume(value)

func _on_volume_slider_value_changed(value: float) -> void:
	if bus:
		spin_box.value = value
		bus.set_volume(value)
