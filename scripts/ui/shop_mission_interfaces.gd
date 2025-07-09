extends CanvasLayer
class_name ShopMissionInterface

@onready var shop: TabBar = $TabContainer/Shop
@onready var missions: TabBar = $TabContainer/Mission
@onready var margin_container : MarginContainer = $MarginContainer

signal start_mission
signal ship_fly

func open_missions() -> void:
	self.show()
	missions.show()

func open_shop() -> void:
	self.show()
	shop.show()

func close_all() -> void:
	self.hide()

func _on_mission_start_button_pressed() -> void:
	emit_signal("start_mission")

func _on_shop_tab_button_pressed() -> void:
	open_shop()

func _on_mission_tab_button_pressed() -> void:
	open_missions()

func _on_exit_button_pressed() -> void:
	close_all()
	emit_signal("ship_fly")
