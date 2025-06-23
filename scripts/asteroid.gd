extends RigidBody3D

var move_dir : Vector3 = Vector3.ZERO
var speed = 100
var ACCELERATION = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#custom_integrator = true
	linear_velocity = move_dir
	



func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#linear_velocity = move_dir
	pass



func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
