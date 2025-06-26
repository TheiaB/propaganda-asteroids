extends Node

class_name MissionManager
var zone_home : ZoneHome

enum DeliveryStates {EMPTY,DELIVERING}
var current_delivery_state: DeliveryStates = DeliveryStates.EMPTY

var destination_planet:ZonePlanet

var proximity_planet : ZonePlanet
var ship : Ship
var arrow: Arrow3D

@export var basePosition: Node3D
@export var zonePlanets: Array[ZonePlanet]
@onready var game: Game

signal start_mission
signal finish_mission

func _ready() -> void:
	game = get_tree().get_root().get_node("Game")
	zone_home = preload("res://scenes/zones/zone_home.tscn").instantiate()
	
func init(gameScene: Node, _arrow:Arrow3D) -> void:
	arrow = _arrow
	gameScene.add_child(zone_home)
	zone_home.global_position = basePosition.global_position
	zone_home.player_entered.connect(on_home_zone_player_entered)
	# guide to home at first
	arrow.ship = ship
	arrow.destination_position = zone_home.global_position
	
	for zone_planet in zonePlanets:
		zone_planet.player_entered.connect(player_entered_planet_zone)
		zone_planet.proximity_entered.connect(player_entered_planet_proximity)
		zone_planet.proximity_exited.connect(player_exited_planet_proximity)
	
func on_home_zone_player_entered(_zone):
	if(current_delivery_state == DeliveryStates.EMPTY):
		print('mission: player entered home and picked up cargo')
		#game.open_missions.emit()
		#_start_mission()
		emit_signal("start_mission")
		
func player_entered_planet_zone(zone:ZonePlanet):
	print('mission: player entered planet', zone.name)
	if(current_delivery_state == DeliveryStates.DELIVERING):
		if(zone == destination_planet):
			print('mission: player delivered')
			_finish_mission()
			emit_signal("finish_mission")
		else:
			print('mission: wrong planet')
			pass
	pass
	
func player_entered_planet_proximity(zone : ZonePlanet):
	print('mission: player entered planet proximity')
	if zone.health <= 1 : 
		proximity_planet = zone
	#get planet specifics and change music?

func player_exited_planet_proximity():
	proximity_planet = null
	print('mission: left planet proximity')
	
func asteroid_timer(asteroid_manager : AsteroidManager):
	asteroid_manager.create_asteroid(ship, proximity_planet)

func _finish_mission():
	current_delivery_state = DeliveryStates.EMPTY
	if(ship != null):
		ship.unequip_cargo()
	#destination_planet = null
	#arrow.hide()
	#arrow.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Guide back home
	#arrow.ship = ship
	arrow.destination_position = zone_home.global_position
	#arrow.process_mode = Node.PROCESS_MODE_INHERIT
	#arrow.show()

func _start_mission() -> void:
	current_delivery_state = DeliveryStates.DELIVERING
	if(ship != null):
		ship.equip_cargo()
	
	# Guide to planet
	destination_planet = zonePlanets.pick_random()
	#arrow.ship = ship
	arrow.destination_position = destination_planet.global_position
	#arrow.process_mode = Node.PROCESS_MODE_INHERIT
	#arrow.show()
