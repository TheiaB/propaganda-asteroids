extends Node3D

class_name asteroid_manager

@export var target_path : NodePath = ""
var target : Node = null

var asteroid_scene : PackedScene = preload("res://scenes/asteroids/asteroid.tscn")
var spawn_distance_offset : float = 10
var asteroid_types = [
	preload("res://scenes/asteroids/asteroid.tscn"),
	preload("res://scenes/asteroids/small_asteroid.tscn"),
	preload("res://scenes/asteroids/big_asteroid.tscn")
]

func _ready() -> void:
	target = get_node_or_null(target_path)


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
	
func set_planet_asteroid_position(planet : ZonePlanet):
	#TODO get precise factory locations
	return Vector3(planet.global_position.x,0,planet.global_position.z)

func spawn_asteroid(bound_force : float, hp : float, max_speed : float, amount : float) -> void:
	if target == null:
		return
	for i in range(amount):
		var asteroid : Node = asteroid_scene.instantiate()
		asteroid.position = set_rand_asteroid_position()
		asteroid.speed = max_speed
		asteroid.health = hp
		asteroid.set_move_dir(bound_force, target)
		add_sibling(asteroid)

func create_asteroid(ship, planet : ZonePlanet):
	if target == null and ship != null:
		target = ship
	elif target == null and ship == null:
		return
	var bound_force = randf_range(0.5,1)
	spawn_random_asteroid(bound_force)
	if planet : spawn_planet_asteroid(bound_force, planet)
	

func spawn_random_asteroid(bound_force : float):
	if target == null:
		return
	var AsteroidScene = asteroid_types[randi() % asteroid_types.size()]
	var asteroid_instance = AsteroidScene.instantiate()
	asteroid_instance.position = set_rand_asteroid_position()
	asteroid_instance.set_move_dir(bound_force, target)
	add_sibling(asteroid_instance)
	
#TODO should use a different move_dir
func spawn_planet_asteroid(bound_force : float, planet : ZonePlanet):
	if target == null:
		return
	var AsteroidScene = asteroid_types[randi() % asteroid_types.size()]
	var asteroid_instance = AsteroidScene.instantiate()
	asteroid_instance.position = set_planet_asteroid_position(planet)
	asteroid_instance.set_move_dir(bound_force, target)
	add_sibling(asteroid_instance)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Asteroids"):
		body.queue_free()
