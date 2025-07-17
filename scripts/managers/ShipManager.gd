extends Node

class_name ShipManager
@onready var projectiles: Node = $Projectiles

var ship : Ship
var camera_3d : Camera3D
var arrow : Arrow3D
var game : Game

signal ship_died
signal money_spent(cost : int)

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
	ship.connect("money_spent", send_money_spent)
	game.ship = ship
	game.updateShip()
	
func update_loadout(item : Item) -> void:
	if item is Weapon:
		ship.weapon.buyable = true
		ship.weapon = item
	elif item is Shield:
		ship.shield.buyable = true
		ship.shield = item
	elif item is Generic_Active_Item:
		ship.active_item.buyable = true
		ship.active_item = item
	else:
		ship.items.append(item)

func send_ship_died():
	emit_signal("ship_died")
	
func send_money_spent(cost : int):
	emit_signal("money_spent", cost)
