extends Node3D

@onready var lasers: Node = $Lasers
@onready var ship: Ship = $Ship

@onready var zone_home: ZoneHome = $Mission/ZoneHome
@onready var zone_planets: Array[ZonePlanet] = [$Mission/ZonePlanet, $Mission/ZonePlanet2]

enum DeliveryStates {EMPTY,DELIVERING}
var current_delivery_state: DeliveryStates = DeliveryStates.EMPTY

func _ready():
	zone_home.player_entered.connect(player_entered_home_zone)
	for zone_planet:ZonePlanet in zone_planets:
		zone_planet.player_entered.connect(player_entered_planet_zone)
	pass
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)

var destination_planet:ZonePlanet

func player_entered_home_zone(zone):
	if(current_delivery_state == DeliveryStates.EMPTY):
		print('game: player entered home and picked up cargo')
		current_delivery_state = DeliveryStates.DELIVERING
		ship.equip_cargo()
		destination_planet = zone_planets.pick_random()

func player_entered_planet_zone(zone:ZonePlanet):
	print('game: player entered planet', zone.name)
	if(current_delivery_state == DeliveryStates.DELIVERING):
		if(zone == destination_planet):
			print('game: player delivered')
			ship.unequip_cargo()
		else:
			print('game: wrong planet')
			pass
	pass

func _process(delta: float) -> void:
	pass
