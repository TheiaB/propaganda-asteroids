extends Generic_Active_Item

var shield : Projectile

func _ready() -> void:
	item_scene = preload("res://scenes/projectiles/active_shield_effect.tscn")
	description = "Use this shield in the right moment. \n" 
	description += "To protect yourself from harm. \n For the low cost of only 1$"
	activation_cost = 1
	price = 10

func activate_item(ship: Ship):
	if ship:
		if !shield:
			shield = item_scene.instantiate()
			shield.ship = ship
			ship.projectiles_node.add_child(shield)
			shield.global_position = ship.global_position
			shield.rotation = ship.rotation
		
func deactivate_item(ship : Ship):
	if ship:
		if shield:
			shield.ship = null
			ship.projectiles_node.remove_child(shield)
			shield.queue_free()
			shield = null
