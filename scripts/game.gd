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
@export_range(0, 100, 1) var resource_fuel:int = 100


@export var zoneHome: ZoneHome
@export var zonePlanets: Array[ZonePlanet]
var firstTime : bool

func _ready():
	GlobalCameraManager.init(camera_3d)
	SoundManager5000.init()
	mission_manager.init(arrow)
	asteroid_manager.init()
	ship_manager.init(camera_3d, arrow, self)
	ui_manager.init(self, mission_manager)
	firstTime = true

	ui_manager.set_displayed_missions(mission_manager.available_missions)
	asteroid_manager.set_difficulty(1)
	#asteroid_manager.spawn_asteroids()
	
	for pair in [["menu_open", pause], ["menu_close", unpause], ["esc", esc], ["new_game", new_game]]:
		if not GlobalMenu.is_connected(pair[0], pair[1]):
			GlobalMenu.connect(pair[0], pair[1])
	
	#GlobalMenu.connect("menu_open",pause)
	#GlobalMenu.connect("menu_close",unpause)
	#GlobalMenu.connect("esc",esc)
	#GlobalMenu.connect("new_game", new_game)
	
func new_game():
	print("heyooooo")
	asteroid_manager.despawn_all_asteroids()
	mission_manager.reset_missions()
	ZoneManager.reset_planets()
	if ship:
		ship.queue_free()
	GlobalCameraManager.reset()
	_ready()
	ui_manager.setUI("contract_scene")
	print("ready")
	#unpause()

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

func unpause():
	process_mode = Node.PROCESS_MODE_ALWAYS
	FmodServer.set_global_parameter_by_name("PauseScreen", 0.0)

func updateShip():
	asteroid_manager.ship = ship
	mission_manager.ship = ship
	ship_manager.ship = ship
	

func _on_ship_manager_ship_died() -> void:
	timer_manager.stopFuel()
	asteroid_manager.spawn_dead_ship(ship.global_position, ship.velocity)
	ui_manager.setUI("death_scene")
	asteroid_manager.add_ship_asteroids()

func _on_fuel_timer_timeout() -> void:
	if self.resource_fuel <= 0:
		ui_manager.setUI("death_scene")
		asteroid_manager.add_ship_asteroids()
		asteroid_manager.spawn_dead_ship(ship.global_position, ship.velocity.normalized())
	else:
		self.resource_fuel -= 3
	

func _on_ui_manager_on_death_scene_next_run() -> void:
	SoundManager5000.music_ambience.stop()
	ui_manager.setUI("contract_scene")
	timer_manager.stopFuel()
	asteroid_manager.stop_asteroids()
	asteroid_manager.despawn_all_asteroids()


func _on_ui_manager_on_contract_accept() -> void:
	ship_manager.spawn_ship()
	ui_manager.setUI()
	SoundManager5000.music_ambience.play()
	GlobalMoneyManager.resource_money = 50000
	mission_manager.reset_current_mission()
	refuel()
	timer_manager.startFuel()
	asteroid_manager.spawn_asteroids()
	GlobalItemManager.reset_stock()
	if !firstTime:
		ship_manager.update_loadout(GlobalItemManager.find("protect_y"))
		print("current shield", ship_manager.ship.shield)
	firstTime = false
	
	
func _on_ui_manager_on_shop_mission_interfaces_start_mission(mission: Mission) -> void:
	mission_manager.start_mission(mission)
	ui_manager.setUI("close_all")


func _on_ui_manager_on_start_run() -> void:
	ship_manager.spawn_ship()
	ui_manager.setUI()


func _on_mission_manager_finish_mission(mission : Mission) -> void:
	mission_manager.add_mission_to_finished_missions(mission)
	asteroid_manager.increase_difficulty()
	ui_manager.clear_missions()
	ui_manager.mission_finish_popup(mission)

func refuel() -> void:
	self.resource_fuel = 100

func _on_ui_manager_purchased_item(unique_name: String) -> void:
	var item = GlobalItemManager.get_item(unique_name)
	if (item.price <= GlobalMoneyManager.resource_money):
		GlobalMoneyManager.resource_money -= item.price
		ship_manager.update_loadout(item)
		GlobalItemManager.bought_item(item)
		SoundManager5000.buy_button_sfx.play_one_shot()
		ui_manager.update_shop(ship)
	else:
		ui_manager.no_money_popup.show_popup()
		SoundManager5000.error_button.play_one_shot()


func _on_ui_manager_ship_fly() -> void:
	#aka exit space station
	if ship:
		ship.activate_set_sail_behaviour(2.0)
		timer_manager.startFuel()
		asteroid_manager.spawn_asteroids()
		

func _on_mission_manager_enter_base() -> void:
	print("entered base")
	timer_manager.stopFuel()
	refuel()
	asteroid_manager.stop_asteroids()
	asteroid_manager.despawn_all_asteroids()
	ui_manager.update_shop(ship)
	if ship:
		ship.activate_docking_behaviour()
	ui_manager.setUI("open_missions")
	#ui_manager.set_displayed_missions(mission_manager.missions)



func _on_ui_manager_on_mission_finished_popup_button_pressed(mission: Mission) -> void:
	print('---- finish mission')
	print(mission)
	mission.finish_mission()
	ui_manager.set_displayed_missions(mission_manager.get_remaining_missions())
	GlobalMoneyManager.resource_money += mission.reward
	

func _on_ship_manager_activate_active_item() -> void:
	if GlobalMoneyManager.resource_money > ship.active_item.activation_cost:
		GlobalMoneyManager.resource_money -= ship.active_item.activation_cost
		timer_manager.startActive()
		ship_manager.ship.active_item.activate_item(ship_manager.ship)
		

func _on_ship_manager_deactivate_active_item() -> void:
	timer_manager.active_item_money_timer.stop()
	ship_manager.ship.active_item.deactivate_item(ship_manager.ship)



func _on_active_item_money_timer_timeout() -> void:
	if ship:
		if ship.active_item:
			GlobalMoneyManager.resource_money -= ship.active_item.activation_cost
			if GlobalMoneyManager.resource_money < ship.active_item.activation_cost:
				print("Deactivating due to insufficient funds")
				ship_manager.ship.active_item.deactivate_item(ship_manager.ship)
				timer_manager.active_item_money_timer.stop()
