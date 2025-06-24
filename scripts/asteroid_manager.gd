extends Node3D

class_name asteroid_manager

@export var target_path : NodePath = ""
var target : Node = null

var asteroid_scene : PackedScene = preload("res://scenes/asteroid.tscn")
var spawn_distance_offset : float = 20

func _ready() -> void:
	target = get_node_or_null(target_path)

func _process(delta : float) -> void:
	pass

func get_new_asteroid_position() -> Vector3:
	var rand_ang: float = randf_range(0, 2 * PI)
	# Use cosine and sine to get direction on the XZ-plane
	var spawn_offset: Vector3 = Vector3(cos(rand_ang), 0, sin(rand_ang)) * spawn_distance_offset
	
	# Replace this with your actual center in 3D world space
	var center: Vector3 = Vector3(0, 0, 0)
	var spawn_location: Vector3 = center + spawn_offset
	return spawn_location
	

func spawn_asteroid(bound_force : float, hp : float, max_speed : float, amount : float) -> void:
	if target == null:
		return
	for i in range(amount):
		var asteroid : Node = asteroid_scene.instantiate()
		asteroid.position = get_new_asteroid_position()
		asteroid.speed = max_speed
		asteroid.health = hp
		asteroid.set_move_dir(bound_force, target)

		add_sibling(asteroid)


func _on_asteroid_timer_timeout() -> void:
	if target == null:
		return
	spawn_asteroid(0.5, 1, 7, 1)
