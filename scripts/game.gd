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



func _ready():
	mission_manager.init(self, arrow)
	timer_manager.startAll()
	
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
	death_scene.visible = false
	start_scene.visible = false
	mission_manager.ship = ship

func _on_death_scene_next_run() -> void:
	spawn_ship()

func _on_start_run_start_run() -> void:
	spawn_ship()
	
func _on_asteroid_timer_timeout() -> void:
	mission_manager.asteroid_timer(asteroid_manager)

func change_money_by(value:int):
	resource_money += value
	label_money_amount.text = str(resource_money)
	pass
