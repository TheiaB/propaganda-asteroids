extends Node

class_name UIManager

@onready var death_scene: Node2D = $death_scene
@onready var start_scene: Node2D = $start_scene
@onready var contract_scene: Node2D = $contract_scene

@onready var shop_mission_interface: ShopMissionInterface = %ShopMissionInterfaces
@onready var fuel_amount_slider: HSlider = %fuel_amount_slider

@onready var label_money_amount: Label = %LabelMoneyAmount
@onready var confirmation_popup : PopupPanel = %ConfirmationPopup

signal on_start_run
signal on_death_scene_next_run
signal on_shop_mission_interfaces_start_mission
signal purchased_item(item_title : String)
signal on_contract_accept
signal ship_fly


func init(_game: Game):
	fuel_amount_slider.game = _game
	label_money_amount.game = _game	
	

func setUI(ui_name: String = ""):
	death_scene.visible = false
	start_scene.visible = false
	contract_scene.visible = false
	
	if ui_name == "death_scene":
		death_scene.visible = true
	
	if ui_name == "start_scene":
		start_scene.visible = true
	
	if ui_name == "contract_scene":
		contract_scene.visible = true
		
	if ui_name == "open_missions":
		shop_mission_interface.open_missions()
		
	if ui_name == "close_all":
		shop_mission_interface.close_all()



func _on_start_run() -> void:
	emit_signal("on_start_run")


func _on_death_scene_next_run() -> void:
	emit_signal("on_death_scene_next_run")


func _on_shop_mission_interfaces_start_mission() -> void:
	emit_signal("on_shop_mission_interfaces_start_mission")
	emit_signal("ship_fly")


func _on_confirmation_popup_terms_accepted(item_title: String) -> void:
	emit_signal('purchased_item', item_title)


func _on_contract_scene_accept_contract() -> void:
	emit_signal("on_contract_accept")
	
func _on_grid_container_panel_buy_pressed(item_data: Variant) -> void:
	confirmation_popup.show_popup(item_data)


func _on_shop_mission_interfaces_ship_fly() -> void:
	emit_signal("ship_fly")
