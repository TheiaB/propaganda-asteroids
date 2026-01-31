extends Projectile

class_name ActiveShield

@onready var shield_sprite: Sprite3D = $Sprite3D

var shields = [
	preload("res://assets/ship/passive_shields/passive schild@2x.png"),
	preload("res://assets/ship/passive_shields/passive schild 2@2x.png")
]

func _ready() -> void:
	print("active shield texture")
	print(shield_sprite.texture)
	
func _process(_delta: float) -> void:
	if ship:
		global_position = ship.global_position
		#look_at(ship.global_transform.origin + -ship.global_transform.basis.z, Vector3.UP)
