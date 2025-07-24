extends Node

class_name UIManager

@onready var death_scene: Node2D = $death_scene
@onready var start_scene: Node2D = $start_scene
@onready var contract_scene: Node2D = $contract_scene

@onready var shop_mission_interface: ShopMissionInterface = %ShopMissionInterfaces
@onready var fuel_amount_slider: HSlider = %fuel_amount_slider

@onready var label_money_amount: Label = %LabelMoneyAmount
@onready var confirmation_popup : PopupPanel = %ConfirmationPopup
@onready var no_money_popup : PopupPanel = %NoMoneyPopup
#@onready var mission_popup: PopupPanel = $ShopMissionInterfaces/MissionPopup
@onready var mission_interface: MissionInterface = $ShopMissionInterfaces/TabContainer/Mission
@onready var mission_popup: PanelContainer = $ShopMissionInterfaces/MissionPopup

@onready var notification: Notification = $notification

@onready var shop_grid: ShopGrid = %GridContainer





signal on_start_run
signal on_death_scene_next_run
signal on_shop_mission_interfaces_start_mission
signal purchased_item(item_title : String)
signal on_contract_accept
signal ship_fly
signal on_mission_finished_popup_button_pressed

var mission_manager : MissionManager


func init(_game: Game, _mission_manager: MissionManager):
	fuel_amount_slider.game = _game
	label_money_amount.game = _game	
	mission_manager = _mission_manager


func notify(time: float):
	notification.notify(time)

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
		SoundManager5000.music_gamestart.stop()
		SoundManager5000.music_contract.play()
		
	if ui_name == "open_missions":
		shop_mission_interface.open_missions()
		
	if ui_name == "close_all":
		shop_mission_interface.close_all()

func update_shop():
	shop_grid.init_grid()

func _on_start_run() -> void:
	emit_signal("on_start_run")


func _on_death_scene_next_run() -> void:
	emit_signal("on_death_scene_next_run")


func _on_confirmation_popup_terms_accepted(item_title: String) -> void:
	emit_signal('purchased_item', item_title)

func _on_contract_scene_accept_contract() -> void:
	emit_signal("on_contract_accept")
	

func _on_shop_mission_interfaces_ship_fly() -> void:
	print("space station exited")
	emit_signal("ship_fly")
	
func popup_mission(mission: Mission):
	mission_popup.popup_mission(mission)

func _on_shop_mission_interfaces_mission_open_pressed(mission: Mission) -> void:
	popup_mission(mission)
	
func set_displayed_missions(missions : Array[Mission]):
	mission_interface.set_displayed_mission(missions)

func clear_missions():
	mission_interface.set_displayed_mission([])

func mission_finish_popup(mission: Mission):
	mission_popup.popup_mission_finish(mission)
	
	

func _on_mission_popup_on_mission_popup_button_pressed(mission: Mission) -> void:
	mission_popup.hide()
	SoundManager5000.mission_accept_sfx.play_one_shot()
	SoundManager5000.music_station.stop()
	SoundManager5000.music_ambience.play()
	emit_signal("on_shop_mission_interfaces_start_mission", mission)
	emit_signal("ship_fly")


func _on_mission_popup_on_finish_mission_popup_button_pressed(mission: Mission) -> void:
	mission_popup.hide()
	print('---- finish mission (ui manager)')
	var dest_zone = ZoneManager.get_planet_by_enum(mission.cargo_dest)
	var start_zone = ZoneManager.get_planet_by_enum(mission.cargo_start)
	var texture
	#is gonna fail if both are planets or is only gonna show the second news
	if dest_zone is ZonePlanet:
		print(dest_zone)
		texture = dest_zone.current_news
	if start_zone is ZonePlanet:
		print(start_zone)
		texture = start_zone.current_news
	notification.texture_rect.texture = texture
	notification.show()
	notify(20)
	emit_signal("on_mission_finished_popup_button_pressed", mission)



func _on_grid_container_panel_buy_pressed(item: Item) -> void:
	confirmation_popup.show_popup(item)
	
