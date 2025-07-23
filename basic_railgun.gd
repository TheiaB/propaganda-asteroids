extends Weapon

@export var damage = 5
@export var speed = 100
@export var amount = 1
@export var delay_between = 50
@export var charge_timer = 250
@export var restricted_rotation_multiplier = -0.5
@export var restricted_movement_multiplier = -0.5


func _ready() -> void:
	projectile_scene = preload("res://scenes/projectiles/laser.tscn")
	weapon_damage = damage
	weapon_price = price
	chargeable = true
	
func shoot_projectile(ship: Ship):
	ship.start_restrict_rotation(restricted_rotation_multiplier)
	ship.start_restrict_movement(restricted_movement_multiplier)
	for _i in range(amount):
		if ship:
			var projectile:Projectile = projectile_scene.instantiate()
			projectile.ship = ship
			projectile.destroyable = false
			ship.projectiles_node.add_child(projectile)
			projectile.speed = speed
			projectile.global_position = ship.muzzle.global_position
			projectile.rotation = ship.rotation
			projectile.damage = weapon_damage
			await get_tree().create_timer(delay_between).timeout
	if ship:
		ship.stop_restricted_movement()
		ship.stop_restrict_rotation()

var MAX_SPEED := 70
var ROTATION_SPEED := 15
