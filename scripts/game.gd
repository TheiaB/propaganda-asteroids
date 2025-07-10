extends Node

class_name Game

@onready var asteroid_manager: AsteroidManager = %AsteroidManager
@onready var ship_manager: ShipManager = %ShipManager
@onready var ui_manager: UIManager = %UIManager
@onready var timer_manager: TimerManager = $TimerManager
@onready var mission_manager: MissionManager = %MissionManager
@onready var zone_manager: ZoneManager = %ZoneManager

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
	mission_manager.init(arrow)
	timer_manager.startAll()
	asteroid_manager.init()
	ship_manager.init(camera_3d, arrow, self)
	ui_manager.init(self)
	firstTime = true

	
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
	self.resource_money = 50
	refuel()
	if firstTime:
		ship_manager.update_loadout(GlobalItemManager.get_rand_item())
		firstTime = false
	
	
func _on_ui_manager_on_shop_mission_interfaces_start_mission() -> void:
	mission_manager.start_mission(mission_manager.get_random_mission())
	ui_manager.setUI("close_all")


func _on_ui_manager_on_start_run() -> void:
	ship_manager.spawn_ship()
	ui_manager.setUI()


func _on_mission_manager_finish_mission() -> void:
	pass # Replace with reward

func refuel() -> void:
	self.resource_fuel = 100

func _on_ui_manager_purchased_item(item_title: String) -> void:
	var item = GlobalItemManager.get_item(item_title)
	if (item.price <= self.resource_money):
		self.resource_money -= item.price
		ship_manager.update_loadout(item)
		item.buyable = false
		$UIManager/ShopMissionInterfaces/TabContainer/Shop/ShopInterface/ScrollContainer/GridContainer.init_grid()
	else:
		ui_manager.no_money_popup.show_popup()


func _on_ui_manager_ship_fly() -> void:
	if ship:
		ship.activate_set_sail_behaviour(2.0)
		timer_manager.fuel_timer.start()


func _on_mission_manager_enter_base() -> void:
	refuel()
	timer_manager.fuel_timer.stop()
	if ship:
		ship.activate_docking_behaviour()
	ui_manager.setUI("open_missions")
