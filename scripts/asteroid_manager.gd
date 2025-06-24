extends Node3D

@export var spawn_rate : float = 0.5
var spawn_rate_left : float = 0

@export var target_path : NodePath = ""
var target : Node = null

var asteroid_scene : PackedScene = preload("res://scenes/asteroid.tscn")
var asteroid_speed : float = 10
var spawn_distance_offset : float = 20

func _ready() -> void:
	randomize()
	spawn_rate_left = spawn_rate
	target = get_node_or_null(target_path)

func _process(delta : float) -> void:
	if target == null:
		return

	# If spawn_rate_left hits 0, then spawn an asteroid, and reset the timer.
	if spawn_rate_left <= 0:
		spawn_asteroid()
		spawn_rate_left = spawn_rate
	
	# If the spawn_rate_left is higher than 0, then decrement it.
	if spawn_rate_left > 0:
		spawn_rate_left -= delta

func get_new_asteroid_position() -> Vector3:
	var rand_ang: float = randf_range(0, 2 * PI)
	
	# Use cosine and sine to get direction on the XZ-plane
	var spawn_offset: Vector3 = Vector3(cos(rand_ang), 0, sin(rand_ang)) * spawn_distance_offset
	
	# Replace this with your actual center in 3D world space
	var center: Vector3 = Vector3(0, 0, 0)
	
	var spawn_location: Vector3 = center + spawn_offset

	return spawn_location

func spawn_asteroid() -> void:
	if target == null:
		return

	# Spawn the asteroid.
	var asteroid : Node = asteroid_scene.instantiate()
	
	# Find a random position to spawn the asteroid to.
	asteroid.position = get_new_asteroid_position()
	
	asteroid.speed = randf_range(2.0, 15)
	
	# Set the asteroid move_dir towards target.
	var offset : Vector3 = target.position - asteroid.position
	asteroid.move_dir = offset.normalized() * asteroid_speed
	# Add the asteroid to the scene.
	add_sibling(asteroid) 
