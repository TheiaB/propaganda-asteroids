extends Node

class_name Mission

@export var title : String
@export var text : String
@export var finish_text: String
@export var reward : int

@export var start : ZoneManager.Planets
@export var destination : ZoneManager.Planets
enum Progress {NOT_STARTED, STARTED, REACHED_FRIST, REACHED_SECOND, FINISHED}
var mission_progress : Progress = Progress.NOT_STARTED

var ship : Ship

func init(_ship: Ship) -> void:
	ship = _ship

func reset() -> void:
	mission_progress = 0

func try_next(planet: Zone):
	if is_correct_planet(planet):
		mission_progress += 1
		return true
	else:
		return false

func is_correct_planet(planet: Zone) -> bool:
	if mission_progress == Progress.NOT_STARTED:
		return planet == ZoneManager.get_home_planet()
	if mission_progress == Progress.STARTED:
		return planet == get_start_planet()
	if mission_progress == Progress.REACHED_FRIST:
		return planet == get_destination_planet()
	return planet == ZoneManager.get_home_planet()

func is_at_destination(planet: Zone) -> bool:
	return planet == get_destination_planet()
	
func is_at_start(planet: Zone) -> bool:
	return planet == get_start_planet()

func get_destination_planet() -> ZonePlanet:
	return ZoneManager.get_planet_by_enum(destination)
	
func get_start_planet() -> ZonePlanet:
	return ZoneManager.get_planet_by_enum(start)
	
