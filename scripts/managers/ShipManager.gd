extends Node

class_name ShipManager
@onready var projectiles: Node = $Projectiles

var ship : Ship
var camera_3d : Camera3D
var arrow : Arrow3D
var game : Game

signal ship_died
signal activate_active_item
signal deactivate_active_item

func init(_camera_3d: Camera3D, _arrow: Arrow3D, _game: Game) -> void:
	camera_3d = _camera_3d
	arrow = _arrow
	game = _game

func spawn_ship() -> void:
	if ship != null:
		ship.queue_free()
	ship = Ship.new().createBasic(camera_3d, projectiles)
	arrow.ship = ship
	game.add_child(ship)
	ship.connect("ship_died", send_ship_died)
	ship.connect("activate_active_item", send_activate_active_item)
	ship.connect("deactivate_active_item", send_deactivate_active_item)
	game.ship = ship
	game.updateShip()
	
func update_loadout(item : Item) -> void:
	if item is Weapon:
		ship.weapon.in_stock = true
		if ship.weapon != null:
			ship.weapon.on_unequip()
		ship.weapon = item
		item.on_equip()
	elif item is Shield:
		ship.shield.in_stock = true
		if ship.shield != null:
			ship.shield.on_unequip()
		ship.shield = item
		item.on_equip()
	elif item is Generic_Active_Item:
		if ship.active_item:
			ship.active_item.in_stock = true
			ship.active_item.on_unequip()
		ship.active_item = item
		item.on_equip()
	else:
		ship.items.append(item)
		item.on_equip()
	

func send_ship_died():
	emit_signal("ship_died")
	ship.weapon.on_unequip()
	ship.shield.on_unequip()
	for item in ship.items:
		item.on_unequip()
	if ship.active_item:
		ship.active_item.on_unequip()
	
	
func send_activate_active_item():
	emit_signal("activate_active_item")
	
func send_deactivate_active_item():
	emit_signal("deactivate_active_item")
