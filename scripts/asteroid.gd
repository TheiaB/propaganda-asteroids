extends RigidBody3D

var move_dir : Vector3 = Vector3.ZERO
var speed = 100
var ACCELERATION = 3.0

@export var health = 3
@export var damage = 3

func _ready() -> void:
	linear_velocity = move_dir


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	
func _on_area_3d_area_entered(bullet: Area3D) -> void:
	health -= bullet.damage
	bullet.queue_free()
	if health <= 0:
		queue_free()


func _on_area_3d_body_entered(ship: Ship) -> void:
	ship.on_collision_with_asteroid(damage)
	queue_free()
