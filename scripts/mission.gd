extends Node

class_name Mission

@export var title : String
@export var text : String
@export var finish_text: String
@export var reward : int

@export var cargo_start : ZoneManager.Planets
@export var cargo_dest  : ZoneManager.Planets

var arrow : Arrow3D

var mission_progress = 0


func init(_arrow: Arrow3D) -> void:
	arrow = _arrow

func reset() -> void:
	mission_progress = 0

func update_cargo_start_is_home_mission(_ship: Ship, _planet: Zone) -> GlobalStatesManager.MissionState:
	if _planet == get_cargo_start_planet() and mission_progress == 0:
		_ship.equip_cargo()
		return update_progress_and_arrow(GlobalStatesManager.MissionState.RUNNING, get_cargo_dest_planet())
	elif _planet == get_cargo_dest_planet() and mission_progress == 1:
		_ship.unequip_cargo()
		return update_progress_and_arrow(GlobalStatesManager.MissionState.DELIVERED)
	elif _planet == ZoneManager.get_home_planet() and mission_progress == 2:
		return update_progress_and_arrow(GlobalStatesManager.MissionState.FINISHED)
	return GlobalStatesManager.MissionState.ERROR

func update_cargo_dest_is_home_mission(_ship: Ship, _planet: Zone) -> GlobalStatesManager.MissionState:
	if _planet == ZoneManager.get_home_planet() and mission_progress == 0:
		return update_progress_and_arrow(GlobalStatesManager.MissionState.RUNNING, get_cargo_start_planet())
	elif _planet == get_cargo_start_planet() and mission_progress == 1:
		_ship.equip_cargo()
		return update_progress_and_arrow(GlobalStatesManager.MissionState.RUNNING)
	elif _planet == get_cargo_dest_planet() and mission_progress == 2:
		_ship.unequip_cargo()
		return update_progress_and_arrow(GlobalStatesManager.MissionState.FINISHED)
	return GlobalStatesManager.MissionState.ERROR

func update_cargo_never_home(_ship: Ship, _planet: Zone) -> GlobalStatesManager.MissionState:
	if _planet == ZoneManager.get_home_planet() and mission_progress == 0:
		return update_progress_and_arrow(GlobalStatesManager.MissionState.RUNNING, get_cargo_start_planet())
	elif _planet == get_cargo_start_planet() and mission_progress == 1:
		_ship.equip_cargo()
		return update_progress_and_arrow(GlobalStatesManager.MissionState.RUNNING, get_cargo_dest_planet())
	elif _planet == get_cargo_dest_planet() and mission_progress == 2:
		_ship.unequip_cargo()
		return update_progress_and_arrow(GlobalStatesManager.MissionState.DELIVERED)
	elif _planet == ZoneManager.get_home_planet() and mission_progress == 3:
		return update_progress_and_arrow(GlobalStatesManager.MissionState.FINISHED)
	return GlobalStatesManager.MissionState.ERROR


func update_mission_state(_ship: Ship, _planet: Zone) -> GlobalStatesManager.MissionState:
	if _ship == null:
		return GlobalStatesManager.MissionState.NO_SHIP
	if get_cargo_start_planet() == ZoneManager.get_home_planet():
		return update_cargo_start_is_home_mission(_ship, _planet)
	elif get_cargo_dest_planet() == ZoneManager.get_home_planet():
		return update_cargo_dest_is_home_mission(_ship, _planet)
	else:
		return update_cargo_never_home(_ship, _planet)
	return GlobalStatesManager.MissionState.ERROR

func update_progress_and_arrow(ret_val:GlobalStatesManager.MissionState, _zone: Zone = ZoneManager.get_home_planet()) -> GlobalStatesManager.MissionState:
	mission_progress += 1
	arrow.destination_position = _zone.global_position
	return ret_val

func get_cargo_start_planet() -> ZonePlanet:
	return ZoneManager.get_planet_by_enum(cargo_start)

func get_cargo_dest_planet() -> ZonePlanet:
	return ZoneManager.get_planet_by_enum(cargo_dest)
	
