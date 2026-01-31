extends Node

var camera: Player_Camera

@export var ground_y := 0.0
@export var spawn_margin := 5.0

var last_camera_pos := Vector3.ZERO
var camera_velocity := Vector3.ZERO

func _process(delta):
	if camera:
		camera_velocity = (camera.global_position - last_camera_pos) / max(delta, 0.0001)
		last_camera_pos = camera.global_position


func _ready() -> void:
	pass

func init(_camera: Player_Camera) -> void:
	camera = _camera
	camera.offset.y += 2.5
	
	
func get_visible_rect_xz() -> Rect2:
	if not camera:
		push_error("CameraManager: Camera not initialized")
		return Rect2()

	var viewport_size := get_viewport().get_visible_rect().size

	var min_x := INF
	var max_x := -INF
	var min_z := INF
	var max_z := -INF

	var screen_corners := [
		Vector2(0, 0),
		Vector2(viewport_size.x, 0),
		Vector2(viewport_size.x, viewport_size.y),
		Vector2(0, viewport_size.y)
	]

	for screen_pos in screen_corners:
		var origin := camera.project_ray_origin(screen_pos)
		var dir := camera.project_ray_normal(screen_pos)

		var t := (ground_y - origin.y) / dir.y
		var world_pos := origin + dir * t

		min_x = min(min_x, world_pos.x)
		max_x = max(max_x, world_pos.x)
		min_z = min(min_z, world_pos.z)
		max_z = max(max_z, world_pos.z)

	return Rect2(
		Vector2(min_x, min_z),
		Vector2(max_x - min_x, max_z - min_z)
	)

func get_spawn_point_outside_view() -> Vector3:
	if not camera:
		push_error("CameraManager: Camera not initialized")
		return Vector3.ZERO

	var visible_rect := get_visible_rect_xz()
	var expanded := visible_rect.grow(spawn_margin)
	var move_dir := Vector2(camera_velocity.x, camera_velocity.z)
	var side := choose_spawn_side(move_dir)

	match side:
		0: # left
			return Vector3(
				expanded.position.x,
				ground_y,
				randf_range(expanded.position.y, expanded.end.y)
			)
		1: # right
			return Vector3(
				expanded.end.x,
				ground_y,
				randf_range(expanded.position.y, expanded.end.y)
			)
		2: # top (-Z)
			return Vector3(
				randf_range(expanded.position.x, expanded.end.x),
				ground_y,
				expanded.position.y
			)
		3: # bottom (+Z)
			return Vector3(
				randf_range(expanded.position.x, expanded.end.x),
				ground_y,
				expanded.end.y
			)

	# fallback
	return Vector3.ZERO
	
func choose_spawn_side(move_dir: Vector2) -> int:
	if move_dir.length() < 0.1:
		return randi() % 4  # player is basically idle

	move_dir = move_dir.normalized()

	var weights := {
		0: max(-move_dir.x, 0.0), # left
		1: max(move_dir.x, 0.0),  # right
		2: max(-move_dir.y, 0.0), # top (-Z)
		3: max(move_dir.y, 0.0),  # bottom (+Z)
	}

	# add a little randomness so it's not predictable
	for k in weights:
		weights[k] += 0.25

	return weighted_random(weights)

func weighted_random(weights: Dictionary) -> int:
	var total := 0.0
	for v in weights.values():
		total += v

	var r := randf() * total
	for k in weights:
		r -= weights[k]
		if r <= 0.0:
			return k

	return weights.keys()[0]

	
func is_point_inside_despawn_area(world_pos: Vector3, margin := 15.0) -> bool:
	var rect := get_visible_rect_xz().grow(margin)
	return rect.has_point(Vector2(world_pos.x, world_pos.z))
