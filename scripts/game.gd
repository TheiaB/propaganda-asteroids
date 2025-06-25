extends Node3D


@onready var zone_home: ZoneHome = $Mission/ZoneHome
@onready var zone_planets: Array[ZonePlanet] = [$Mission/ZonePlanet, $Mission/ZonePlanet2, $Mission/ZonePlanet3]
@onready var as_timer : Node = $AsteroidTimer
@onready var asteroid_manager: asteroid_manager = %AsteroidManager
@onready var projectiles: Node = %Projectiles
@onready var item_manager: ItemManager = %ItemManager

var ship: Ship

enum DeliveryStates {EMPTY,DELIVERING}
var current_delivery_state: DeliveryStates = DeliveryStates.EMPTY

var destination_planet:ZonePlanet
@onready var arrow: Arrow3D = $Camera3D/Arrow
@onready var death_scene: Node2D = $UI/death_scene
@onready var start_scene: Node2D = $UI/start_scene
@onready var camera_3d: Player_Camera = %Camera3D

func _ready():
	zone_home.player_entered.connect(player_entered_home_zone)
	for zone_planet:ZonePlanet in zone_planets:
		zone_planet.player_entered.connect(player_entered_planet_zone)
	as_timer.start()
	
	print(item_manager.get_all_items())
	


func player_entered_home_zone(_zone):
	if(current_delivery_state == DeliveryStates.EMPTY):
		print('game: player entered home and picked up cargo')
		current_delivery_state = DeliveryStates.DELIVERING
		ship.equip_cargo()
		destination_planet = zone_planets.pick_random()
		arrow.ship = ship
		arrow.destination_position = destination_planet.global_position
		arrow.process_mode = Node.PROCESS_MODE_INHERIT
		arrow.show()

func player_entered_planet_zone(zone:ZonePlanet):
	print('game: player entered planet', zone.name)
	if(current_delivery_state == DeliveryStates.DELIVERING):
		if(zone == destination_planet):
			print('game: player delivered')
			current_delivery_state = DeliveryStates.EMPTY
			ship.unequip_cargo()
			destination_planet = null
			arrow.hide()
			arrow.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			print('game: wrong planet')
			pass
	pass

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

func _on_death_scene_next_run() -> void:
	spawn_ship()

func _on_start_run_start_run() -> void:
	spawn_ship()
	
func _on_asteroid_timer_timeout() -> void:
	asteroid_manager.create_asteroid(ship)
