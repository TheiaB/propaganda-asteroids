extends CharacterBody3D

class_name Ship

@export var stats : CharacterStats

signal player_hit_static_body
signal laser_shot

@export var weapon: Weapon
@export var shield: Shield
@export var items: Array[Generic_Item]

@onready var muzzle := $Muzzle

var laser_scene = preload("res://scenes/laser.tscn")

func load_item_attributes():
	stats.load_attributes(self)
	
	for item in items:
		item.load_attributes(self)

func _ready() -> void:
	load_item_attributes()

func on_collide_with_static_body(collision:KinematicCollision3D):
	emit_signal("player_hit_static_body")
	
func on_collision_with_asteroid(damage):
	shield.health -= damage
	if shield.health <= 0:
		queue_free()
	
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot_laser()
		
func shoot_laser():
	var laser := laser_scene.instantiate()
	get_parent().add_child(laser)
	laser.global_position = muzzle.global_position
	laser.rotation = rotation
	laser.damage = weapon.weapon_damage
	emit_signal("laser_shot", laser)
	
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		rotate_y(stats.ROTATION_SPEED * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-stats.ROTATION_SPEED * delta)

	var input_vector = Vector3(0, 0, -Input.get_axis("break", "gas"))

	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized()
		var direction = (global_transform.basis * input_vector)
		velocity = velocity.move_toward(direction * stats.MAX_SPEED, stats.ACCELERATION * delta)
	else:
		if velocity.x <= stats.MIN_SPEED_THRESHOLD and velocity.z <= stats.MIN_SPEED_THRESHOLD:
			velocity = velocity.move_toward(Vector3.ZERO, stats.DECELERATION_AFTER_THRESHOLD * delta)
		else:
			velocity = velocity.move_toward(Vector3.ZERO, stats.DECELERATION * delta)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		on_collide_with_static_body(collision)

@onready var cargo: MeshInstance3D = $Cargo
func equip_cargo():
	cargo.show()
	pass

func unequip_cargo():
	cargo.hide()
	pass
