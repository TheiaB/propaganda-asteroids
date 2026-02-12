extends Node3D

class_name AsteroidManager

@export var target_path : NodePath = ""
var target : Node = null
@onready var asteroid_timer: Timer = $AsteroidTimer
@onready var planet_as_timer : Timer = $PlanetTimer

var asteroid_scene : PackedScene = preload("res://scenes/asteroids/asteroid.tscn")
var spawn_distance_offset : float = 14

var asteroid_count : int = 0


enum EnemyTier { COMMON, UNCOMMON, RARE, SPECIAL }
var spawn_weights := []  
var asteroid_speed_factor_range : Vector2
var bound_force_range : Vector2
var t : float
#TODO Fix rarity and reconfigure special asteroid types
var asteroid_types = [
	{ "scene": preload("res://scenes/asteroids/small_asteroid.tscn"), "tier": EnemyTier.RARE },
	{ "scene": preload("res://scenes/asteroids/asteroid.tscn"), "tier": EnemyTier.COMMON},
	{ "scene": preload("res://scenes/asteroids/asteroid_satelite-1.tscn"), "tier": EnemyTier.COMMON},
	{ "scene": preload("res://scenes/asteroids/asteroid_satelite-2.tscn"), "tier": EnemyTier.UNCOMMON},
	{ "scene": preload("res://scenes/asteroids/big_asteroid.tscn"), "tier": EnemyTier.UNCOMMON},
]
var planet_asteroids = []

var ship : Ship
var proximity_planet : ZonePlanet

var current_difficulty_level:int

func _ready() -> void:
	target = get_node_or_null(target_path)

func init() -> void:
	for zone_planet in ZoneManager.get_planets():
		zone_planet.proximity_entered.connect(player_entered_planet_proximity)
		zone_planet.proximity_exited.connect(player_exited_planet_proximity)

func spawn_asteroids() -> void:
	print("spawning asteroids")
	asteroid_timer.start()
	
func stop_asteroids() -> void:
	print("asteroid spawning stopped")
	asteroid_timer.stop()
	
func despawn_all_asteroids() -> void:
	for asteroid in get_tree().get_nodes_in_group("Asteroids"):
			print("despawning all asteroids")
			asteroid.queue_free()
			GlobalAsteroidManager.reset_asteroid_count()

func increase_difficulty(levels:int=1):
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
	t = float(level - 1) / 9.0
	asteroid_timer.wait_time = lerp(1.0, 0.1, t)
	spawn_weights.clear()
	bound_force_range.x = lerp(0.501, 0.85, t)
	bound_force_range.y = lerp(0.7, 0.95, t)
	asteroid_speed_factor_range.x = lerp(0.3, 0.9, t)
	asteroid_speed_factor_range.y = lerp(0.5, 1.0, t)
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
		add_spawn_weight(tier)

func add_spawn_weight(tier: EnemyTier):
	match tier:
			EnemyTier.COMMON:
				spawn_weights.append(lerp(0.6, 0.1, t))
			EnemyTier.UNCOMMON:
				spawn_weights.append(lerp(0.3, 0.5, t))
			EnemyTier.RARE:
				spawn_weights.append(lerp(0.1, 0.4, t))
			EnemyTier.SPECIAL:
				spawn_weights.append(0.0)



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
	elif zone.unique_name == "antplanet":
		SoundManager5000.music_ant_planet.play()
	elif zone.unique_name == "crystalplanet":
		SoundManager5000.music_crystal_planet.play()
	if zone.health == 2:
		if zone.unique_name == "waterplanet":
			SoundManager5000.music_ocean_planet.set_parameter("OceanDecay", 1)
			print("OceanDecay 1")
		elif zone.unique_name == "antplanet":
			SoundManager5000.music_ant_planet.set_parameter("AntDecay", 1)
			print("AntDecay 1")
		elif zone.unique_name == "crystalplanet":
			SoundManager5000.music_ant_planet.set_parameter("CrystalDecay", 1)
			print("CrystalDecay 1")
	if zone.health <= 1 : 
		if zone.unique_name == "waterplanet":
			SoundManager5000.music_ocean_planet.set_parameter("OceanDecay", 2)
			print("OceanDecay 2")
			asteroid_types.append({ "scene": preload("res://scenes/asteroids/water_asteroid.tscn"), "tier": EnemyTier.UNCOMMON})
			add_spawn_weight(EnemyTier.UNCOMMON)
			#planet_asteroids.append({ "scene": preload("res://scenes/asteroids/water_asteroid.tscn"), "tier": EnemyTier.SPECIAL, "name" : "waterplanet"})
		elif zone.unique_name == "antplanet":
			SoundManager5000.music_ant_planet.set_parameter("AntDecay", 2)
			print("AntDecay 2")
			asteroid_types.append({ "scene": preload("res://scenes/asteroids/termite_asteroid.tscn"), "tier": EnemyTier.COMMON})
			add_spawn_weight(EnemyTier.COMMON)
			#planet_asteroids.append(	{ "scene": preload("res://scenes/asteroids/termite_asteroid.tscn"), "tier": EnemyTier.SPECIAL, "name" : "antplanet"})
		elif zone.unique_name == "crystalplanet":
			SoundManager5000.music_ant_planet.set_parameter("CrystalDecay", 2)
			print("CrystalDecay 2")
			asteroid_types.append({ "scene": preload("res://scenes/asteroids/crystal_asteroid.tscn"), "tier": EnemyTier.RARE})
			add_spawn_weight(EnemyTier.RARE)
			#planet_asteroids.append(	{ "scene": preload("res://scenes/asteroids/crystal_asteroid.tscn"), "tier": EnemyTier.SPECIAL, "name" : "crystalplanet"})
		#proximity_planet = zone
		#planet_as_timer.start()
		
		
func spawn_dead_ship(ship_position : Vector3, ship_direction:Vector3):
	#get current ship location
	#get current ship move direction
	var scene = preload("res://scenes/asteroids/ship_asteroid.tscn")
	var asteroid_instance:Asteroid = scene.instantiate()
	asteroid_instance.position = ship_position
	var direction = Node3D.new()
	var distance = 5.0
	asteroid_instance.speed = 0.7
	direction.global_position = ship_position + ship_direction * distance
	#what if i dont move?
	asteroid_instance.set_move_dir(1, direction)
	add_sibling(asteroid_instance)
	

func add_ship_asteroids():
	asteroid_types.append({ "scene": preload("res://scenes/asteroids/ship_asteroid.tscn"), "tier": EnemyTier.RARE})
	add_spawn_weight(EnemyTier.RARE)

func player_exited_planet_proximity():
	proximity_planet = null
	#planet_as_timer.stop()
	spawn_asteroids()
	SoundManager5000.music_ambience.play()
	SoundManager5000.music_ant_planet.stop()
	SoundManager5000.music_ocean_planet.stop()
	SoundManager5000.music_crystal_planet.stop()
	print('game: left planet proximity')

func set_rand_asteroid_position() -> Vector3:
	return GlobalCameraManager.get_spawn_point_outside_view()
	

func get_box_radius(area: Area3D) -> float:
	var collision = area.get_node("CollisionShape3D")  # Adjust the path
	var shape = collision.shape
	if shape is BoxShape3D:
		var extents = shape.size * 0.5
		return extents.length()
	else:
		push_warning("Shape is not a BoxShape3D!")
		return 0.0	


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
	#var valid_enemies = []
	#var valid_weights = []
	#for i in range(asteroid_types.size()):
		#if spawn_weights[i] > 0.0:
			#valid_enemies.append(asteroid_types[i])
			#valid_weights.append(spawn_weights[i])

	var chosen = pick_weighted(asteroid_types, spawn_weights)
	var asteroid_instance:Asteroid = chosen.scene.instantiate()
	var inherent_speed = asteroid_instance.speed
	asteroid_instance.position = set_rand_asteroid_position()
	asteroid_instance.speed = inherent_speed * randf_range(asteroid_speed_factor_range.x, asteroid_speed_factor_range.y)
	asteroid_instance.set_move_dir(_bound_force, target)
	add_sibling(asteroid_instance)
	

func increase_asteroid_count():
	GlobalAsteroidManager.asteroid_count += 1
	#print(GlobalAsteroidManager.asteroid_count)
	
func decrease_asteroid_count():
	GlobalAsteroidManager.asteroid_count -= 1
	#print(GlobalAsteroidManager.asteroid_count)

func reset_asteroid_count():
	GlobalAsteroidManager.asteroid_count = 0

func _on_asteroid_timer_timeout() -> void:
	#TODO maybe number of max asteroids per level?
	create_asteroid(ship, bound_force_range)
	increase_asteroid_count()
