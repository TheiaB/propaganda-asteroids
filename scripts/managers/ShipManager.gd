extends Node

class_name ShipManager
@onready var projectiles: Node = $Projectiles

var ship : Ship
var camera_3d : Camera3D
var arrow : Arrow3D
var game : Game

signal ship_died

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
	game.ship = ship
	game.updateShip()

func send_ship_died():
	emit_signal("ship_died")
