extends Node

@onready var zone_home: ZoneHome = $ZoneHome
@onready var planets : Array[ZonePlanet] = [$ZonePlanet1, $ZonePlanet2, $ZonePlanet3]

enum Planets { zone_planet_1, zone_planet_2, zone_planet_3 }
		
func get_home_planet() -> ZoneHome:
	return zone_home
	
func get_planets() -> Array[ZonePlanet]:
	return planets
	
func get_planet_by_enum(planet: Planets) -> ZonePlanet:
	if planet < len(planets) and planet >=0 :
		return planets[planet]
	return planets[0]
