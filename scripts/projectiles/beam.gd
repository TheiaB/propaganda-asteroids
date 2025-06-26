extends Projectile

func _ready() -> void:
	destroyable = false
	$LingerTimer.start()
	
func _physics_process(_delta: float) -> void:
	if ship:
		global_position = ship.global_position
		look_at(ship.global_transform.origin + -ship.global_transform.basis.z, Vector3.UP)

func _on_linger_timer_timeout() -> void:
	queue_free()
