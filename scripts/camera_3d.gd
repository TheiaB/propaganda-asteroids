extends Camera3D
class_name Player_Camera

@export var follow_target: Node3D

@export var offset: Vector3 = Vector3(0, $".".position.y, 0)
@export var smooth_speed: float = 5.0

func _process(delta: float) -> void:
	if follow_target:
		var target_pos = follow_target.global_transform.origin + offset
		var current_pos = global_transform.origin
		global_transform.origin = current_pos.lerp(target_pos, smooth_speed * delta)
