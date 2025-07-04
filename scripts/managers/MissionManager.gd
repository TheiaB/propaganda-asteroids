extends Node

class_name MissionManager
var zone_home : ZoneHome
var zone_planets : Array[ZonePlanet]

enum DeliveryStates {EMPTY,DELIVERING}
var current_delivery_state: DeliveryStates = DeliveryStates.EMPTY

var destination_planet:ZonePlanet

var ship : Ship
var arrow: Arrow3D

signal start_mission
signal finish_mission

func _ready() -> void:
	zone_home = preload("res://scenes/zones/zone_home.tscn").instantiate()
	
func init(_arrow:Arrow3D, _zone_home:ZoneHome, _zone_planets:Array[ZonePlanet]) -> void:
	arrow = _arrow
	zone_home = _zone_home
	zone_planets = _zone_planets
	zone_home.player_entered.connect(on_home_zone_player_entered)
	# guide to home at first
	arrow.ship = ship
	arrow.destination_position = zone_home.global_position
	
	for zone_planet in zone_planets:
		zone_planet.player_entered.connect(player_entered_planet_zone)
	
func on_home_zone_player_entered(_zone):
	if(current_delivery_state == DeliveryStates.EMPTY):
		print('mission: player entered home and picked up cargo')
		#_start_mission()
		emit_signal("start_mission")
		print('game: player entered home and picked up cargo')
		current_delivery_state = DeliveryStates.DELIVERING
		ship.equip_cargo()
		destination_planet = zone_planets.pick_random()
		arrow.ship = ship
		arrow.destination_position = destination_planet.global_position
		arrow.process_mode = Node.PROCESS_MODE_INHERIT
		arrow.show()
		
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
	destination_planet = zone_planets.pick_random()
	#arrow.ship = ship
	arrow.destination_position = destination_planet.global_position
	#arrow.process_mode = Node.PROCESS_MODE_INHERIT
	#arrow.show()
