extends Weapon

@export var damage = 1
@export var speed = 10
@export var amount = 1
@export var delay_between = 0.0
@export var restricted_roation_multiplier = -1.0
@export var restricted_movement_multiplier = -1.0

func _ready() -> void:
	projectile_scene = preload("res://scenes/laser.tscn")
	weapon_damage = damage
	
func shoot_projectile(ship: Ship):
	ship.start_restrict_rotation(restricted_roation_multiplier)
	ship.start_restrict_movement(restricted_movement_multiplier)
	for _i in range(amount):
		if ship:
			var projectile:Projectile = projectile_scene.instantiate()
			projectile.ship = ship
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
