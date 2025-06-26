extends Projectile

var initial_velocity

func _ready() -> void:
	initial_velocity = ship.velocity

func _physics_process(delta: float) -> void:
	var bullet_direction = -transform.basis.z * speed
	global_position += (bullet_direction + initial_velocity) * delta

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
