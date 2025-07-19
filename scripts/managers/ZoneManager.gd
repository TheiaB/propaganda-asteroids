extends Node

@onready var zone_home: ZoneHome = $ZoneHome
@onready var zone_planet_1: ZonePlanet = $ZonePlanet1
@onready var zone_planet_2: ZonePlanet = $ZonePlanet2
@onready var zone_planet_3: ZonePlanet = $ZonePlanet3

@onready var planets: Array[ZonePlanet] = [zone_planet_1, zone_planet_2, zone_planet_3]


enum Planets { HOME, PLANET1, PLANET2, PLANET3 }
		
func get_home_planet() -> ZoneHome:
	return zone_home
	
func get_planets() -> Array[ZonePlanet]:
	return planets
	
func get_planet_by_enum(planet: Planets) -> Zone:
	match planet:
		Planets.HOME:
			return zone_home
		Planets.PLANET1:
			return zone_planet_1
		Planets.PLANET2:
			return zone_planet_2
		Planets.PLANET3:
			return zone_planet_3
		_:
			return zone_home
