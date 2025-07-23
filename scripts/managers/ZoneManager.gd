extends Node3D

@onready var zone_home: ZoneHome = $ZoneHome
@onready var zone_planet_water: ZonePlanet = $ZonePlanetWater
@onready var zone_planet_ant: ZonePlanet = $ZonePlanetAnt
@onready var zone_planet_crystal: ZonePlanet = $ZonePlanetCrystal

@onready var planets: Array[ZonePlanet] = [zone_planet_water, zone_planet_ant, zone_planet_crystal]


enum Planets { HOME, PLANET_WATER, PLANET_ANT, PLANET_CRYSTAL }
		
func get_home_planet() -> ZoneHome:
	return zone_home
	
func get_planets() -> Array[ZonePlanet]:
	return planets
	
func get_planet_by_enum(planet: Planets) -> Zone:
	match planet:
		Planets.HOME:
			return zone_home
		Planets.PLANET_WATER:
			return zone_planet_water
		Planets.PLANET_ANT:
			return zone_planet_ant
		Planets.PLANET_CRYSTAL:
			return zone_planet_crystal
		_:
			return zone_home
