extends Node

class_name MissionManager
var zone_home : ZoneHome
var zone_planets : Array[ZonePlanet]

enum DeliveryStates {EMPTY,DELIVERING}
var current_delivery_state: DeliveryStates = DeliveryStates.EMPTY

@onready var missions : Array[Mission] = []
var finished_missions : Array[Mission] = []

var current_mission: Mission

var ship : Ship
var arrow: Arrow3D

signal enter_base
signal finish_mission

func _ready() -> void:
	for child in get_children():
		if child is Mission:
			missions.append(child)
	zone_home = preload("res://scenes/zones/zone_home.tscn").instantiate()

func init(_arrow:Arrow3D) -> void:
	arrow = _arrow
	zone_home = ZoneManager.get_home_planet()
	zone_planets = ZoneManager.get_planets()
	zone_home.player_entered.connect(on_home_zone_player_entered)
	# guide to home at first
	arrow.ship = ship
	arrow.destination_position = zone_home.zone_area.global_position
	
	for zone_planet in zone_planets:
		zone_planet.player_entered.connect(player_entered_planet_zone)

	for mission in missions:
		mission.init(arrow)
	
func on_home_zone_player_entered(_zone):
	emit_signal("enter_base")
	SoundManager5000.music_ambience.stop()
	SoundManager5000.music_station.set_parameter("Dock", 1)
	SoundManager5000.music_station.play()
	print("station entered")

	if current_mission != null:
		var erg = current_mission.update_mission_state(ship, _zone)
		match erg:
				GlobalStatesManager.MissionState.FINISHED:
					emit_signal("finish_mission", current_mission)
				_:
					print("default_behaviour: ", erg)


func player_entered_planet_zone(_zone:ZonePlanet):
	if(current_mission != null):
		if(current_delivery_state == DeliveryStates.DELIVERING):
			current_mission.update_mission_state(ship, _zone)
	

func start_mission(mission: Mission) -> void:
	current_delivery_state = DeliveryStates.DELIVERING
	current_mission = mission
	arrow.ship = ship

	match current_mission.update_mission_state(ship, ZoneManager.get_home_planet()):
		GlobalStatesManager.MissionState.RUNNING:
			arrow.process_mode = Node.PROCESS_MODE_INHERIT
			arrow.show()
		_:
			pass
	
func get_random_mission() -> Mission:
	return missions.pick_random()


func add_mission_to_finished_missions(mission: Mission):
	finished_missions.append(mission)

func get_remaining_missions() -> Array[Mission]:
	return missions.filter(func(x): return x not in finished_missions)
