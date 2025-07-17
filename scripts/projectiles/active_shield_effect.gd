extends Projectile

class_name ActiveShield

func _ready() -> void:
	destroyable = false
	
func _process(_delta: float) -> void:
	if ship:
		global_position = ship.global_position
		#look_at(ship.global_transform.origin + -ship.global_transform.basis.z, Vector3.UP)
