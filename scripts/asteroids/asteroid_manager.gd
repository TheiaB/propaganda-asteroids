extends Node3D

class_name AsteroidManager

@export var target_path : NodePath = ""
var target : Node = null
@onready var asteroid_timer: Timer = $AsteroidTimer
@onready var planet_as_timer : Timer = $PlanetTimer

var asteroid_scene : PackedScene = preload("res://scenes/asteroids/asteroid.tscn")
var spawn_distance_offset : float = 10
var asteroid_types = [
	preload("res://scenes/asteroids/asteroid.tscn"),
	preload("res://scenes/asteroids/small_asteroid.tscn"),
	preload("res://scenes/asteroids/big_asteroid.tscn")
]

var ship : Ship
var proximity_planet : ZonePlanet

func _ready() -> void:
	target = get_node_or_null(target_path)

func init(zone_planets: Array[ZonePlanet]) -> void:
	for zone_planet in zone_planets:
		zone_planet.proximity_entered.connect(player_entered_planet_proximity)
		zone_planet.proximity_exited.connect(player_exited_planet_proximity)
	asteroid_timer.start()


func player_entered_planet_proximity(zone : ZonePlanet):
	print('game: player entered planet proximity')
	if zone.health <= 1 : 
		proximity_planet = zone
		planet_as_timer.start()
	#get planet specifics and change music?

func player_exited_planet_proximity():
	proximity_planet = null
	planet_as_timer.stop()
	print('game: left planet proximity')
	


func set_rand_asteroid_position() -> Vector3:
	var camera = get_node("../Camera3D") as Camera3D
	if not camera:
		push_error("Camera3D not found!")
		return Vector3.ZERO
	var rand_ang: float = randf_range(0, 2 * PI)
	# Use cosine and sine to get direction on the XZ-plane
	var spawn_offset: Vector3 = Vector3(cos(rand_ang), 0, sin(rand_ang)) * spawn_distance_offset
	# Replace this with your actual center in 3D world space
	var center: Vector3 = camera.global_transform.origin
	var spawn_location: Vector3 = Vector3(center.x,0,center.z) + spawn_offset
	return spawn_location
	
func get_box_radius(area: Area3D) -> float:
	var collision = area.get_node("CollisionShape3D")  # Adjust the path
	var shape = collision.shape
	if shape is BoxShape3D:
		var extents = shape.size * 0.5
		return extents.length()
	else:
		push_warning("Shape is not a BoxShape3D!")
		return 0.0	

func set_planet_asteroid_position(planet : ZonePlanet):
	var random_dir = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	return planet.global_position + random_dir * get_box_radius(planet.get_node('ZoneArea'))

func create_asteroid(_ship):
	if target == null and _ship != null:
		target = _ship
	elif target == null and _ship == null:
		return
	var bound_force = randf_range(0.5,1)
	spawn_random_asteroid(bound_force)

		
func create_planet_asteroid(planet : ZonePlanet):
	if planet :
		spawn_planet_asteroid(planet)
	

func spawn_random_asteroid(bound_force : float):
	if target == null:
		return
	var AsteroidScene = asteroid_types[randi() % asteroid_types.size()]
	var asteroid_instance = AsteroidScene.instantiate()
	asteroid_instance.position = set_rand_asteroid_position()
	asteroid_instance.set_move_dir(bound_force, target)
	add_sibling(asteroid_instance)
	
func spawn_planet_asteroid(planet : ZonePlanet):
	if target == null:
		return
	#TODO spawn the correct asteroid that corresponds to the planet
	var AsteroidScene = asteroid_types[randi() % asteroid_types.size()]
	var asteroid_instance = AsteroidScene.instantiate()
	asteroid_instance.position = set_planet_asteroid_position(planet)
	asteroid_instance.set_move_dir(0, planet)
	add_sibling(asteroid_instance)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Asteroids"):
		body.queue_free()


func _on_asteroid_timer_timeout() -> void:
	create_asteroid(ship)


func _on_planet_timer_timeout() -> void:
	create_planet_asteroid(proximity_planet)
