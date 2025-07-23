extends CanvasLayer
class_name ShopMissionInterface

@onready var shop: TabBar = $TabContainer/Shop
@onready var missions: TabBar = $TabContainer/Mission
@onready var margin_container : MarginContainer = $MarginContainer


signal mission_open_pressed
signal ship_fly

func open_missions() -> void:
	self.show()
	missions.show()

func open_shop() -> void:
	self.show()
	shop.show()

func close_all() -> void:
	self.hide()

func _on_shop_tab_button_pressed() -> void:
	SoundManager5000.music_station.set_parameter("Dock", 0)
	open_shop()

func _on_mission_tab_button_pressed() -> void:
	SoundManager5000.music_station.set_parameter("Dock", 1)
	open_missions()

func _on_exit_button_pressed() -> void:
	close_all()
	SoundManager5000.music_station.stop()
	SoundManager5000.music_ambience.play()
	emit_signal("ship_fly")
	

func _on_mission_open_mission_button(mission: Mission) -> void:
	emit_signal("mission_open_pressed", mission)
