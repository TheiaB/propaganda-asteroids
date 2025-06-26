extends Node

class_name Game

#@onready var as_timer : Node = $AsteroidTimer
@onready var asteroid_manager: AsteroidManager = %AsteroidManager
@onready var projectiles: Node = %Projectiles

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
	
func _on_fuel_timer_timeout() -> void:
	resource_fuel -= 10
	
func _on_ship_died():
	death_scene.visible = true

func spawn_ship() -> void:
	if ship != null:
		ship.queue_free()
	ship = Ship.new().createBasic(camera_3d, projectiles)
	arrow.ship = ship
	add_child(ship)
	ship.connect("ship_died", _on_ship_died)
	mission_manager._finish_mission()
	death_scene.visible = false
	start_scene.visible = false
	mission_manager.ship = ship
	asteroid_manager.ship = ship
	
func _on_death_scene_next_run() -> void:
	spawn_ship()

func _on_start_run_start_run() -> void:
	spawn_ship()
	
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
	shop_mission_interface.open_missions()


func _on_mission_manager_finish_mission() -> void:
	pass # Replace with function body.
