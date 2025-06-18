extends Area3D

@export var speed := 50

func _physics_process(delta: float) -> void:
	global_position -= transform.basis.z * speed * delta

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
