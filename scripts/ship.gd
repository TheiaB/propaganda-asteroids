extends CharacterBody3D

class_name Ship

@export var stats : CharacterStats

signal ship_died

@export var weapon: Weapon
@export var shield: Shield
@export var items: Array[Generic_Item]
var isInvinsible: bool = false
var projectiles_node: Node
var charge_start_time : float = 0.0

@onready var muzzle := $Muzzle
@onready var invincibility_timer: Timer = $InvincibilityTimer

@onready var thruster: FmodEventEmitter3D = $ThrusterLoop
var thruster_state_on := false


var is_on_port: bool = false

func activate_docking_behaviour():
	is_on_port = true
	setInvinsibility(true)

func activate_set_sail_behaviour(_delay):
	is_on_port = false
	delayedInvinsibilityReset(_delay)
	

func setInvinsibility(_isInvinsible:bool):
	isInvinsible = _isInvinsible
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", isInvinsible) 

func delayedInvinsibilityReset(_delay:float):
	invincibility_timer.wait_time = _delay
	invincibility_timer.start()

func _on_invincibility_timer_timeout() -> void:
	setInvinsibility(false)

func createBasic(camera: Player_Camera, _projectiles_node: Node):
	var _weapon = preload("res://scenes/items/weapons/basic_weapon.tscn").instantiate()
	var _shield = preload("res://scenes/items/shields/basic_shield.tscn").instantiate()
	var _stats = preload("res://scenes/basic_start_stats.tscn").instantiate()
	return create(camera, _projectiles_node, _weapon, _shield, _stats)


func create(camera: Player_Camera, _projectiles_node: Node, _weapon: Weapon, _shield: Shield, _stats: CharacterStats):
	var ship: Ship = preload("res://scenes/ship.tscn").instantiate()
	ship.weapon = _weapon
	ship.add_child(ship.weapon)	
	ship.shield = _shield
	ship.add_child(ship.shield)	
	ship.stats = _stats
	ship.add_child(ship.stats)
	ship.transform = ship.transform.scaled(Vector3(0.5, 0.5, 0.5))
	ship.projectiles_node = _projectiles_node
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
	if !isInvinsible:
		shield.shield_health -= damage
		if shield.shield_health <= 0:
			emit_signal("ship_died")
			queue_free()
	
func _process(_delta):
	if weapon.chargeable:
		if Input.is_action_pressed("shoot") and weapon.charging == false:
			weapon.charging = true
			charge_start_time = Time.get_ticks_msec()
			start_restrict_rotation(0)
			start_restrict_movement(0)
		if Input.is_action_just_released("shoot"):
			weapon.charging = false
			stop_restricted_movement()
			stop_restrict_rotation()
			var charge_duration = Time.get_ticks_msec() - charge_start_time
			print(charge_duration)
			if weapon.charge_timer <= charge_duration:
				weapon.shoot_projectile(self)
	else:
		if Input.is_action_just_pressed("shoot"):
			weapon.shoot_projectile(self)

	if Input.is_action_pressed("gas"):
		if not thruster_state_on:
			print("start rocket")
			$ThrusterStart.play_one_shot()
			$ThrusterLoop.play()
			thruster_state_on = true
	else:
		if thruster_state_on:
			print("stop rocket")
			$ThrusterLoop.stop()
			$ThrusterStop.play_one_shot()
			thruster_state_on = false
		

func start_restrict_rotation(_restricted_rotation_multiplier):
	self.restricted_rotation_multiplier = _restricted_rotation_multiplier


func stop_restrict_rotation():
	self.restricted_rotation_multiplier = -1
	
func start_restrict_movement(_restricted_movement_multiplier):
	self.restricted_movement_multiplier = _restricted_movement_multiplier
	
func stop_restricted_movement():
	self.restricted_movement_multiplier = -1




func _physics_process(delta):
	var calculated_rotation_speed = stats.ROTATION_SPEED
	
	if restricted_rotation_multiplier >= 0.0:
		calculated_rotation_speed = calculated_rotation_speed * restricted_rotation_multiplier

	if Input.is_action_pressed("left") and not is_on_port:
		rotate_y(calculated_rotation_speed * delta)
	if Input.is_action_pressed("right") and not is_on_port:
		rotate_y(-calculated_rotation_speed * delta)

	var input_vector = Vector3(0, 0, -Input.get_axis("break", "gas"))
	if is_on_port:
		input_vector = Vector3.ZERO
		velocity = Vector3.ZERO
	
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

@onready var cargo: MeshInstance3D = $Cargo
func equip_cargo():
	cargo.show()
	pass

func unequip_cargo():
	cargo.hide()
	pass
	
