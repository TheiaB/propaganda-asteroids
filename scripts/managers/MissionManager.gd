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

func _ready() -> void:
	zone_home = preload("res://scenes/zones/zone_home.tscn").instantiate()
	
func init(gameScene: Node, _arrow:Arrow3D) -> void:
	arrow = _arrow
	gameScene.add_child(zone_home)
	zone_home.global_position = basePosition.global_position
	zone_home.player_entered.connect(on_home_zone_player_entered)
	
	for zone_planet in zonePlanets:
		zone_planet.player_entered.connect(player_entered_planet_zone)
		zone_planet.proximity_entered.connect(player_entered_planet_proximity)
		zone_planet.proximity_exited.connect(player_exited_planet_proximity)
	
func on_home_zone_player_entered(_zone):
	if(current_delivery_state == DeliveryStates.EMPTY):
		print('game: player entered home and picked up cargo')
		current_delivery_state = DeliveryStates.DELIVERING
		ship.equip_cargo()
		destination_planet = zonePlanets.pick_random()
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
	
func player_entered_planet_proximity(zone : ZonePlanet):
	print('game: player entered planet proximity')
	if zone.health <= 1 : 
		proximity_planet = zone
	#get planet specifics and change music?

func player_exited_planet_proximity():
	proximity_planet = null
	print('game: left planet proximity')
	
func asteroid_timer(asteroid_manager : AsteroidManager):
	asteroid_manager.create_asteroid(ship, proximity_planet)
