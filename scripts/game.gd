extends Node

class_name Game

#@onready var as_timer : Node = $AsteroidTimer
@onready var asteroid_manager: AsteroidManager = %AsteroidManager
@onready var ship_manager: ShipManager = %ShipManager
@onready var ui_manager: UIManager = $UI

var ship: Ship

@onready var arrow: Arrow3D = $Camera3D/Arrow
@onready var death_scene: Node2D = $UI/death_scene
@onready var start_scene: Node2D = $UI/start_scene
@onready var camera_3d: Player_Camera = %Camera3D

@export_group("💸 PLAYER RESOURCES")
@export_range(0, 100, 1) var resource_money:int = 50
@export_range(0, 100, 1) var resource_fuel:int = 100

@onready var label_money_amount: Label = $UI/IngameInterface/LabelMoneyAmount

@onready var mission_manager: MissionManager = %MissionManager
@onready var timer_manager: TimerManager = $TimerManager
@onready var shop_mission_interface: ShopMissionInterface = %ShopMissionInterfaces

@export var zoneHome: ZoneHome
@export var zonePlanets: Array[ZonePlanet]

func _ready():
	mission_manager.init(arrow, zoneHome, zonePlanets)
	timer_manager.startAll()
	asteroid_manager.init(zonePlanets)
	ship_manager.init(camera_3d, arrow, self)


func _on_fuel_timer_timeout() -> void:
	resource_fuel -= 10
	
func _on_ship_died():
	death_scene.visible = true

func _on_death_scene_next_run() -> void:
	ship_manager.spawn_ship()
	mission_manager._finish_mission()
	ui_manager.setUI("")


func _on_start_run_start_run() -> void:
	ship_manager.spawn_ship()
	mission_manager._finish_mission()
	ui_manager.setUI("")
	

func change_money_by(value:int):
	resource_money += value
	label_money_amount.text = str(resource_money)


func _on_mission_button_start() -> void:
	mission_manager._start_mission()
	shop_mission_interface.close_all()
	if ship:
		ship.activate_set_sail_behaviour(2.0)


func _on_mission_manager_start_mission() -> void:
	if ship:
		ship.activate_docking_behaviour()
	print('helo')
	shop_mission_interface.open_missions()


func _on_mission_manager_finish_mission() -> void:
	pass # Replace with function body.

func updateShip():
	asteroid_manager.ship = ship
	mission_manager.ship = ship
	ship_manager.ship = ship
