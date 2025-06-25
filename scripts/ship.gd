extends CharacterBody3D

class_name Ship

@export var stats : CharacterStats

signal ship_died


@export var weapon: Weapon
@export var shield: Shield
@export var items: Array[Generic_Item]
var projectiles_node: Node

@onready var muzzle := $Muzzle

func createBasic(camera: Player_Camera, projectiles_node: Node):
	var _weapon = preload("res://scenes/items/weapons/basic_weapon.tscn").instantiate()
	var _shield = preload("res://scenes/items/shields/basic_shield.tscn").instantiate()
	var _stats = preload("res://scenes/basic_start_stats.tscn").instantiate()
	return create(camera, projectiles_node, _weapon, _shield, _stats)

func create(camera: Player_Camera, projectiles_node: Node, _weapon: Weapon, _shield: Shield, _stats: CharacterStats):
	var ship: Ship = preload("res://scenes/ship.tscn").instantiate()
	ship.weapon = _weapon
	ship.add_child(ship.weapon)	
	ship.shield = _shield
	ship.add_child(ship.shield)	
	ship.stats = _stats
	ship.add_child(ship.stats)
	ship.transform = ship.transform.scaled(Vector3(0.5, 0.5, 0.5))
	ship.projectiles_node = projectiles_node
	camera.follow_target = ship
	
	return ship

var restricted_rotation_multiplier = -1
var restricted_movement_multiplier = -1

func load_item_attributes():
	stats = preload("res://scenes/basic_start_stats.tscn").instantiate()
	
	print(global_position)
	stats.load_attributes(self)
		
	for item in items:
		item.load_attributes(self)

func _ready() -> void:
	load_item_attributes()

	
func on_collision_with_asteroid(damage):
	shield.sield_health -= damage
	if shield.sield_health <= 0:
		emit_signal("ship_died")
		queue_free()
	
func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		weapon.shoot_projectile(self)
		
func start_restrict_rotation(restricted_rotation_multiplier):
	self.restricted_rotation_multiplier = restricted_rotation_multiplier

func stop_restrict_rotation():
	self.restricted_rotation_multiplier = -1
	
func start_restrict_movement(restricted_movement_multiplier):
	self.restricted_movement_multiplier = restricted_movement_multiplier
	
func stop_restricted_movement():
	self.restricted_movement_multiplier = -1

	
func _physics_process(delta):
	var calculated_rotation_speed = stats.ROTATION_SPEED
	
	if restricted_rotation_multiplier >= 0.0:
		calculated_rotation_speed = calculated_rotation_speed * restricted_rotation_multiplier
		
	
	if Input.is_action_pressed("left"):
		rotate_y(calculated_rotation_speed * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-calculated_rotation_speed * delta)

	var input_vector = Vector3(0, 0, -Input.get_axis("break", "gas"))
	
	var calculated_max_speed = stats.MAX_SPEED
	if restricted_movement_multiplier >= 0.0:
		calculated_max_speed = calculated_max_speed * restricted_movement_multiplier

	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized()
		var direction = (global_transform.basis * input_vector)
		velocity = velocity.move_toward(direction * calculated_max_speed, stats.ACCELERATION * delta)
	else:
		if velocity.x <= stats.MIN_SPEED_THRESHOLD and velocity.z <= stats.MIN_SPEED_THRESHOLD:
			velocity = velocity.move_toward(Vector3.ZERO, stats.DECELERATION_AFTER_THRESHOLD * delta)
		else:
			velocity = velocity.move_toward(Vector3.ZERO, stats.DECELERATION * delta)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

@onready var cargo: MeshInstance3D = $Cargo
func equip_cargo():
	cargo.show()
	pass

func unequip_cargo():
	cargo.hide()
	pass
