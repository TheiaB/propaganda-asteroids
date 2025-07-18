extends Node

class_name MissionManager
var zone_home : ZoneHome
var zone_planets : Array[ZonePlanet]

enum DeliveryStates {EMPTY,DELIVERING}
var current_delivery_state: DeliveryStates = DeliveryStates.EMPTY

@onready var missions : Array[Mission] = [$BaseMission, $BaseMission2]
var finished_missions : Array[Mission] = []

var current_mission: Mission

var ship : Ship
var arrow: Arrow3D

signal enter_base
signal finish_mission

func _ready() -> void:
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
		mission.init(ship)
	
func on_home_zone_player_entered(_zone):
	emit_signal("enter_base")

	if(current_delivery_state == DeliveryStates.EMPTY):
		if current_mission != null:
			if(current_mission.is_correct_planet(_zone) and ZoneManager.get_home_planet() == _zone):
				current_mission.try_next(_zone)
				current_mission.reset()

				emit_signal("finish_mission", current_mission)


func player_entered_planet_zone(zone:ZonePlanet):
	if(current_mission != null):
		if(current_delivery_state == DeliveryStates.DELIVERING):
			if(current_mission.is_correct_planet(zone) and current_mission.is_at_start(zone)):
				current_mission.try_next(zone)
				if(ship != null):
					ship.equip_cargo()
				arrow.destination_position = current_mission.get_destination_planet().global_position
				
			elif(current_mission.is_correct_planet(zone) and current_mission.is_at_destination(zone)):
				current_mission.try_next(zone)
				current_delivery_state = DeliveryStates.EMPTY
				if(ship != null):
					ship.unequip_cargo()
				arrow.destination_position = ZoneManager.get_home_planet().zone_area.global_position
			else:
				print(current_mission.mission_progress)
	

func start_mission(mission: Mission) -> void:
	current_delivery_state = DeliveryStates.DELIVERING
	current_mission = mission

	arrow.ship = ship

	current_mission.try_next(ZoneManager.get_home_planet())
	arrow.destination_position = current_mission.get_start_planet().global_position
	arrow.process_mode = Node.PROCESS_MODE_INHERIT
	arrow.show()
	
func get_random_mission() -> Mission:
	return missions.pick_random()


func add_mission_to_finished_missions(mission: Mission):
	finished_missions.append(mission)

func get_remaining_missions() -> Array[Mission]:
	return missions.filter(func(x): return x not in finished_missions)
