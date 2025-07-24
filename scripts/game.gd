extends Node

class_name Game

@onready var asteroid_manager: AsteroidManager = %AsteroidManager
@onready var ship_manager: ShipManager = %ShipManager
@onready var ui_manager: UIManager = %UIManager
@onready var timer_manager: TimerManager = $TimerManager
@onready var mission_manager: MissionManager = %MissionManager
#@onready var zone_manager: ZoneManager = %ZoneManager

var ship: Ship

@onready var arrow: Arrow3D = $Camera3D/Arrow
@onready var camera_3d: Player_Camera = %Camera3D

@export_group("💸 PLAYER RESOURCES")
@export_range(0, 100, 1) var resource_money:int = 50
@export_range(0, 100, 1) var resource_fuel:int = 100


@export var zoneHome: ZoneHome
@export var zonePlanets: Array[ZonePlanet]
var firstTime : bool

func _ready():
	GlobalCameraManager.init(camera_3d)
	SoundManager5000.init()
	mission_manager.init(arrow)
	timer_manager.startAll()
	asteroid_manager.init()
	ship_manager.init(camera_3d, arrow, self)
	ui_manager.init(self, mission_manager)
	firstTime = true

	ui_manager.set_displayed_missions(mission_manager.missions)
	asteroid_manager.set_difficulty(1)
	
	GlobalMenu.connect("menu_open",pause)
	GlobalMenu.connect("menu_close",unpause)
	GlobalMenu.connect("menu_restart",fresh_restart)
	GlobalMenu.connect("esc",esc)

func esc():
	if(ui_manager.shop_mission_interface.visible):
		print("close ui")
		ui_manager.shop_mission_interface.close_all()
		ui_manager.shop_mission_interface.emit_signal("ship_fly")
	elif GlobalMenu.visible :
		GlobalMenu.emit_signal("menu_close")
		GlobalMenu.close_menu()
	else:
		print("open menu")
		GlobalMenu.emit_signal("menu_open")

func pause():
	#get_tree().paused = true
	process_mode = Node.PROCESS_MODE_DISABLED
	print("pause")
	FmodServer.set_global_parameter_by_name("PauseScreen", 1.0)
	pass

func unpause():
	process_mode = Node.PROCESS_MODE_ALWAYS
	FmodServer.set_global_parameter_by_name("PauseScreen", 0.0)

	#get_tree().paused = false

func fresh_restart():
	#GlobalItemManager.get_tree().reload_scene()
	#GlobalStatesManager.get_tree().reload_scene()
	#ZoneManager.get_tree().reload_scene()
	#get_tree().reload_scene()
	print("restarting")
	get_tree().reload_current_scene()
	GlobalMenu.open_menu()
	print(SoundManager5000)
	print(SoundManager5000.is_inside_tree())
	#ship.queue_free()

func updateShip():
	asteroid_manager.ship = ship
	mission_manager.ship = ship
	ship_manager.ship = ship
	

func _on_ship_manager_ship_died() -> void:
	ui_manager.setUI("death_scene")

func _on_fuel_timer_timeout() -> void:
	if self.resource_fuel <= 0:
		ui_manager.setUI("death_scene")
	else:
		self.resource_fuel -= 5
	

func _on_ui_manager_on_death_scene_next_run() -> void:
	ui_manager.setUI("contract_scene")


func _on_ui_manager_on_contract_accept() -> void:
	ship_manager.spawn_ship()
	ui_manager.setUI()
	SoundManager5000.music_ambience.play()
	self.resource_money = 50
	refuel()
	if !firstTime:
		ship_manager.update_loadout(GlobalItemManager.get_rand_item())
	firstTime = false
	
	
func _on_ui_manager_on_shop_mission_interfaces_start_mission(mission: Mission) -> void:
	mission_manager.start_mission(mission)
	ui_manager.setUI("close_all")


func _on_ui_manager_on_start_run() -> void:
	ship_manager.spawn_ship()
	ui_manager.setUI()


func _on_mission_manager_finish_mission(mission : Mission) -> void:
	mission_manager.add_mission_to_finished_missions(mission)
	asteroid_manager.add_difficulty()
	ui_manager.clear_missions()
	ui_manager.mission_finish_popup(mission)

func refuel() -> void:
	self.resource_fuel = 100

func _on_ui_manager_purchased_item(item_title: String) -> void:
	var item = GlobalItemManager.get_item(item_title)
	if (item.price <= self.resource_money):
		self.resource_money -= item.price
		ship_manager.update_loadout(item)
		item.in_stock = false
		SoundManager5000.buy_button_sfx.play_one_shot()
		ui_manager.update_shop()
	else:
		ui_manager.no_money_popup.show_popup()
		SoundManager5000.error_button.play_one_shot()


func _on_ui_manager_ship_fly() -> void:
	if ship:
		ship.activate_set_sail_behaviour(2.0)
		timer_manager.startFuel()

func _on_mission_manager_enter_base() -> void:
	refuel()
	ui_manager.update_shop()
	timer_manager.stopFuel()
	if ship:
		ship.activate_docking_behaviour()
	ui_manager.setUI("open_missions")
	#ui_manager.set_displayed_missions(mission_manager.missions)



func _on_ui_manager_on_mission_finished_popup_button_pressed(mission: Mission) -> void:
	print('---- finish mission')
	print(mission)
	mission.finish_mission()
	ui_manager.set_displayed_missions(mission_manager.get_remaining_missions())
	resource_money += mission.reward
	

func _on_ship_manager_activate_active_item() -> void:
	if self.resource_money > ship.active_item.activation_cost:
		self.resource_money -= ship.active_item.activation_cost
		timer_manager.startActive()
		ship_manager.ship.active_item.activate_item(ship_manager.ship)
		

func _on_ship_manager_deactivate_active_item() -> void:
	timer_manager.active_item_money_timer.stop()
	ship_manager.ship.active_item.deactivate_item(ship_manager.ship)



func _on_active_item_money_timer_timeout() -> void:
	self.resource_money -= ship.active_item.activation_cost
	if self.resource_money < ship.active_item.activation_cost:
		print("Deactivating due to insufficient funds")
		ship_manager.ship.active_item.deactivate_item(ship_manager.ship)
		timer_manager.active_item_money_timer.stop()
