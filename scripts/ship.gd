extends CharacterBody3D

@export var ACCELERATION := 2.0
@export var DECELERATION := 0.0
@export var MAX_SPEED := 5.0
@export var ROTATION_SPEED := 1.5
@export var MIN_SPEED_THRESHOLD := 0.1
@export var DECELERATION_AFTER_THRESHOLD := 0.1

signal player_hit_static_body
signal laser_shot

@export var weapon_damage := 1

@onready var muzzle := $Muzzle

var laser_scene = preload("res://scenes/laser.tscn")

func on_collide_with_static_body(collision:KinematicCollision3D):
	emit_signal("player_hit_static_body")
	
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot_laser()
		
func shoot_laser():
	var laser := laser_scene.instantiate()
	get_parent().add_child(laser)
	laser.global_position = muzzle.global_position
	laser.rotation = rotation
	emit_signal("laser_shot", laser)
	
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-ROTATION_SPEED * delta)

	var input_vector = Vector3(0, 0, -Input.get_axis("break", "gas"))

	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized()
		var direction = (global_transform.basis * input_vector)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		if velocity.x <= MIN_SPEED_THRESHOLD and velocity.z <= MIN_SPEED_THRESHOLD:
			velocity = velocity.move_toward(Vector3.ZERO, DECELERATION_AFTER_THRESHOLD * delta)
		else:
			velocity = velocity.move_toward(Vector3.ZERO, DECELERATION * delta)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		on_collide_with_static_body(collision)
