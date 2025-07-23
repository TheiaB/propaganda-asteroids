extends Node3D

class_name AsteroidManager

@export var target_path : NodePath = ""
var target : Node = null
@onready var asteroid_timer: Timer = $AsteroidTimer
@onready var planet_as_timer : Timer = $PlanetTimer

var asteroid_scene : PackedScene = preload("res://scenes/asteroids/asteroid.tscn")
var spawn_distance_offset : float = 9


enum EnemyTier { COMMON, UNCOMMON, RARE, SPECIAL }
var spawn_weights := []  
var planet_asteroids = false
var asteroid_speed_range : Vector2
var bound_force_range : Vector2
var asteroid_types = [
	{ "scene": preload("res://scenes/asteroids/small_asteroid.tscn"), "tier": EnemyTier.COMMON },
	{ "scene": preload("res://scenes/asteroids/asteroid.tscn"), "tier": EnemyTier.UNCOMMON},
	{ "scene": preload("res://scenes/asteroids/asteroid_satelite-1.tscn"), "tier": EnemyTier.RARE},
	{ "scene": preload("res://scenes/asteroids/asteroid_satelite-2.tscn"), "tier": EnemyTier.RARE},
	{ "scene": preload("res://scenes/asteroids/big_asteroid.tscn"), "tier": EnemyTier.RARE},
	{ "scene": preload("res://scenes/asteroids/water_asteroid.tscn"), "tier": EnemyTier.SPECIAL, "name" : "waterplanet"},
	{ "scene": preload("res://scenes/asteroids/termite_asteroid.tscn"), "tier": EnemyTier.SPECIAL, "name" : "antplanet"},
	{ "scene": preload("res://scenes/asteroids/crystal_asteroid.tscn"), "tier": EnemyTier.SPECIAL, "name" : "crystalplanet"}
]

var ship : Ship
var proximity_planet : ZonePlanet

var current_difficulty_level:int

func _ready() -> void:
	target = get_node_or_null(target_path)

func init() -> void:
	for zone_planet in ZoneManager.get_planets():
		zone_planet.proximity_entered.connect(player_entered_planet_proximity)
		zone_planet.proximity_exited.connect(player_exited_planet_proximity)

func add_difficulty(levels:int=1):
	set_difficulty(current_difficulty_level + levels)
	if current_difficulty_level <= 2:
		FmodServer.set_global_parameter_by_name("Space Decay", 0)
	if current_difficulty_level == 3:  
		FmodServer.set_global_parameter_by_name("Space Decay", 1)
	if current_difficulty_level == 5:
		FmodServer.set_global_parameter_by_name("Space Decay", 2)
	if current_difficulty_level == 7:
		FmodServer.set_global_parameter_by_name("Space Decay", 3)
	if current_difficulty_level >= 9: 
		FmodServer.set_global_parameter_by_name("Space Decay", 4)




func set_difficulty(level: int):
	level = clamp(level, 1, 10)
	current_difficulty_level = level
	var t = float(level - 1) / 9.0
	asteroid_timer.wait_time = lerp(0.8, 0.2, t)
	spawn_weights.clear()
	bound_force_range.x = lerp(0.501, 0.9, t)
	bound_force_range.y = lerp(0.7, 1.0, t)
	asteroid_speed_range.x = lerp(2, 4, t)
	asteroid_speed_range.y = lerp(3, 5, t)
	
	print('DIFFICULTY LEVEL: ',level)
	print('Lerp Parameter: ',t)
	print('Bound force: ', bound_force_range)
	print('Speed range: ', asteroid_speed_range)
	if current_difficulty_level <= 2:
		FmodServer.set_global_parameter_by_name("Space Decay", 0)
	if current_difficulty_level == 3:  
		FmodServer.set_global_parameter_by_name("Space Decay", 1)
	if current_difficulty_level == 5:
		FmodServer.set_global_parameter_by_name("Space Decay", 2)
	if current_difficulty_level == 7:
		FmodServer.set_global_parameter_by_name("Space Decay", 3)
	if current_difficulty_level >= 9: 
		FmodServer.set_global_parameter_by_name("Space Decay", 4)
	for i in range(asteroid_types.size()):
		var tier = asteroid_types[i].tier
		match tier:
			EnemyTier.COMMON:
				spawn_weights.append(lerp(0.6, 0.3, t))
			EnemyTier.UNCOMMON:
				spawn_weights.append(lerp(0.3, 0.4, t))
			EnemyTier.RARE:
				spawn_weights.append(lerp(0.1, 0.3, t))
			EnemyTier.SPECIAL:
				spawn_weights.append(0.0)
	asteroid_timer.start()

		
		
		
func pick_weighted(items: Array, weights: Array) -> Variant:
	var total_weight := 0.0
	for weight in weights:
		total_weight += weight
	var r = randf() * total_weight
	var cumulative := 0.0
	for i in range(items.size()):
		cumulative += weights[i]
		if r <= cumulative:
			return items[i]
	# Fallback (shouldn't happen unless weights are misconfigured)
	return items[items.size() - 1]

func player_entered_planet_proximity(zone : ZonePlanet):
	print('game: player entered planet proximity')
	asteroid_timer.stop()
	SoundManager5000.music_ambience.stop()
	if zone.unique_name == "waterplanet":
		SoundManager5000.music_ocean_planet.play()
	if zone.unique_name == "antplanet":
		SoundManager5000.music_ant_planet.play()
	if zone.unique_name == "crystalplanet":
		SoundManager5000.music_crystal_planet.play()
	if zone.health == 2:
		if zone.unique_name == "waterplanet":
			SoundManager5000.music_ocean_planet.set_parameter("OceanDecay", 1)
			print("OceanDecay 1")
		if zone.unique_name == "antplanet":
			SoundManager5000.music_ant_planet.set_parameter("AntDecay", 1)
			print("AntDecay1")
		if zone.unique_name == "crystalplanet":
			SoundManager5000.music_ant_planet.set_parameter("CrystalDecay", 1)
			print("CrystalDecay1")
	if zone.health <= 1 : 
		if zone.unique_name == "waterplanet":
			SoundManager5000.music_ocean_planet.set_parameter("OceanDecay", 2)
			print("OceanDecay 2")
		if zone.unique_name == "antplanet":
			SoundManager5000.music_ant_planet.set_parameter("AntDecay", 2)
			print("AntDecay 2")
		if zone.unique_name == "crystalplanet":
			SoundManager5000.music_ant_planet.set_parameter("CrystalDecay", 2)
			print("CrystalDecay 2")
		proximity_planet = zone
		planet_as_timer.start()
		

func player_exited_planet_proximity():
	proximity_planet = null
	planet_as_timer.stop()
	asteroid_timer.start()
	SoundManager5000.music_ambience.play()
	SoundManager5000.music_ant_planet.stop()
	SoundManager5000.music_ocean_planet.stop()
	SoundManager5000.music_crystal_planet.stop()

	print('game: left planet proximity')

func set_rand_asteroid_position() -> Vector3:
	var camera = get_node("../Camera3D") as Camera3D
	if not camera:
		push_error("Camera3D not found!")
		return Vector3.ZERO
	var rand_ang: float = randf_range(0, 2 * PI)
	# Use cosine and sine to get direction on the XZ-plane
	var spawn_offset: Vector3 = Vector3(cos(rand_ang), 0, sin(rand_ang)) * spawn_distance_offset
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
	return planet.global_position + random_dir

	#return planet.global_position + random_dir * get_box_radius(planet.get_node('ZoneArea'))

func create_asteroid(_ship, _bound_force : Vector2):
	if target == null and _ship != null:
		target = _ship
	elif target == null and _ship == null:
		return
	var bound_force_fin = randf_range(_bound_force.x, _bound_force.y)
	spawn_random_asteroid(bound_force_fin)
	
func spawn_random_asteroid(_bound_force : float):
	if target == null:
		return
	var valid_enemies = []
	var valid_weights = []
	for i in range(asteroid_types.size()):
		if spawn_weights[i] > 0.0:
			valid_enemies.append(asteroid_types[i])
			valid_weights.append(spawn_weights[i])

	var chosen = pick_weighted(valid_enemies, valid_weights)
	var asteroid_instance:Asteroid = chosen.scene.instantiate()
	asteroid_instance.position = set_rand_asteroid_position()
	asteroid_instance.speed = randf_range(asteroid_speed_range.x, asteroid_speed_range.y)
	asteroid_instance.set_move_dir(_bound_force, target)
	add_sibling(asteroid_instance)
	
	
func spawn_planet_asteroid(planet : ZonePlanet):
	if target == null || proximity_planet == null:
		return
	var asteroid_instance
	for i in range(asteroid_types.size()):
		if asteroid_types[i].tier == EnemyTier.SPECIAL:
			var name = asteroid_types[i].name
			if name == planet.unique_name:
				var planet_asteroid = asteroid_types[i].scene
				asteroid_instance = planet_asteroid.instantiate()
				break
	if asteroid_instance:
		asteroid_instance.position = planet.position
		asteroid_instance.set_move_dir(-1,target)
		asteroid_instance.disable()
		add_sibling(asteroid_instance)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Asteroids"):
		body.queue_free()


func _on_asteroid_timer_timeout() -> void:
	create_asteroid(ship, bound_force_range)


func _on_planet_timer_timeout() -> void:
	spawn_planet_asteroid(proximity_planet)
