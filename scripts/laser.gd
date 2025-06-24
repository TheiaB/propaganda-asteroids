extends Projectile

func _physics_process(delta: float) -> void:
	var bullet_direction = -transform.basis.z * speed
	global_position += (bullet_direction + ship.velocity) * delta
	#ship.velocity

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
