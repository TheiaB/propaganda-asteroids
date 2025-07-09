extends Node

class_name UIManager

@onready var death_scene: Node2D = $death_scene
@onready var start_scene: Node2D = $start_scene
@onready var contract_scene: Node2D = $contract_scene

@onready var shop_mission_interface: ShopMissionInterface = %ShopMissionInterfaces
@onready var fuel_amount_slider: HSlider = %fuel_amount_slider

@onready var label_money_amount: Label = %LabelMoneyAmount

signal on_start_run
signal on_death_scene_next_run
signal on_shop_mission_interfaces_start_mission
signal purchased_item(item_title : String)
signal on_contract_accept


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


func _on_item_panel_buy_button_pressed(node: Node) -> void:
	$ConfirmationPopup.show_popup(node)


func _on_confirmation_popup_terms_accepted(item_title: String) -> void:
	emit_signal('purchased_item', item_title)


func _on_contract_scene_accept_contract() -> void:
	emit_signal("on_contract_accept")
