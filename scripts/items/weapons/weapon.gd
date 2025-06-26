extends Item

class_name Weapon

var projectile_scene : Resource
var weapon_damage := 1
var weapon_price : int
var chargeable := false
var charging := false

func shoot_projectile(_ship: Ship):
	pass
