extends RigidBody3D
class_name Asteroid

var move_dir : Vector3 = Vector3.ZERO
var screen_size = DisplayServer.screen_get_size()

@export var speed = 100
@export var health = 3
@export var damage = 1
var rotational_speed_modif = 0.3
@onready var area_3d: Area3D = $Area3D
var is_spawn_invincible : bool = false

func _ready() -> void:
	linear_velocity = move_dir
	var rot_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	angular_velocity = rot_direction * speed  * rotational_speed_modif
	screen_size = get_viewport().get_visible_rect().size
	var all_overlapping_areas:Array[Area3D] = area_3d.get_overlapping_areas()
	for overlapping_area:Area3D in all_overlapping_areas:
		if(overlapping_area.collision_layer == 5): # if its a zone
			print('Asteroid spawned within illegal zone.')
			queue_free()
			pass

# bound fource is e.g. value between 0.7-0.8
# target = ship

func set_move_dir(bound_force : float, target : Node) -> void:
	if bound_force >= 0 :
		var offset : Vector3 = (target.position - position)
		# move_dir = (offset * bound_force + get_random_screen_offset_point() * (1 - bound_force)).normalized() * speed
		var towards_player:Vector3 = offset.normalized() * bound_force
		var random_direction:Vector3 =  Vector3(
	 		randf_range(-1, 1),
			0,
			randf_range(-1, 1)
		).normalized() * (1 - bound_force);
		move_dir = (random_direction + towards_player).normalized() * speed# (towards_player + get_random_screen_offset_point() * (1 - bound_force)).normalized() * speed
	else :
		var angle = randf() * TAU
		var direction = Vector2.from_angle(angle)
		move_dir = Vector3(direction.x,0,direction.y) * speed

func get_random_screen_offset_point() -> Vector3:
	
	var screen_center = screen_size / 2
	var max_offset_x = screen_center.x
	var max_offset_y = screen_center.y
	var offset = Vector3(
 		randf_range(-max_offset_x, max_offset_x),
		0,
		randf_range(-max_offset_y, max_offset_y)
	)
	print(offset)
	return offset
	#return Vector3(screen_center.x,0,screen_center.y) + offset

	
func _on_area_3d_area_entered(area : Area3D) -> void:
	if area is ActiveShield:
		print('activeshield')
		queue_free()
	if area is Projectile:
		SoundManager5000.asteroid_hit_sfx.play_one_shot()
		var bullet := area as Projectile
		health -= bullet.damage
		if bullet.destroyable:
			bullet.queue_free()
		if health <= 0:
			SoundManager5000.asteroid_destroyed_sfx.play_one_shot()
			queue_free()


func _on_area_3d_body_entered(ship) -> void:
	if ship is Ship:
		ship.on_collision_with_asteroid(ship.weapon.weapon_damage)
		queue_free()
	else:
		pass
		
func disable():
	#$Area3D/CollisionShape3D.disabled = true
	set_deferred("disabled", true)
	is_spawn_invincible = true
	
func enable():
	set_deferred("disabled", false)
	is_spawn_invincible = false
	
func destroy_me():
	if !is_spawn_invincible:
		queue_free()

func _process(delta: float) -> void:
	if(linear_velocity.length() > speed * 2.0):
		linear_velocity -= linear_velocity.normalized() * 0.1
	elif(linear_velocity.length() < speed * 0.5):
		linear_velocity += linear_velocity.normalized() * 0.1
	
	if(angular_velocity.length() > speed * rotational_speed_modif * 0.9):
		angular_velocity = angular_velocity.normalized() * speed * rotational_speed_modif
	elif(angular_velocity.length() < speed * rotational_speed_modif * 1.1):
		angular_velocity = angular_velocity.normalized() * speed * rotational_speed_modif
	
