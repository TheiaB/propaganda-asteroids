extends RigidBody3D

var move_dir : Vector3 = Vector3.ZERO
var screen_size = DisplayServer.screen_get_size()

@export var speed = 100
@export var health = 3
@export var damage = 1

func _ready() -> void:
	linear_velocity = move_dir
	screen_size = get_viewport().get_visible_rect().size


func set_move_dir(bound_force : float, target : Node) -> void:
	var offset : Vector3 = (target.position - position).normalized()
	move_dir = (offset * bound_force + get_random_screen_offset_point() * (1 - bound_force)).normalized() * speed


func get_random_screen_offset_point() -> Vector3:
	var screen_center = screen_size / 2
	var max_offset_x = screen_center.x
	var max_offset_y = screen_center.y
	var offset = Vector3(
 		randf_range(-max_offset_x, max_offset_x),
		0,
		randf_range(-max_offset_y, max_offset_y)
	)
	return Vector3(screen_center.x,0,screen_center.y) + offset

	
func _on_area_3d_area_entered(area : Area3D) -> void:
	if area is Projectile:
		var bullet := area as Projectile
		health -= bullet.damage
		bullet.queue_free()
		if health <= 0:
			queue_free()


func _on_area_3d_body_entered(ship: Ship) -> void:
	ship.on_collision_with_asteroid(ship.weapon.weapon_damage)
	queue_free()
	
#TODO better despawning, also despawning if it doesnt enter camera
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
