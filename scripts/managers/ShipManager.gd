extends Node

class_name ShipManager

var ship : Ship

func spawn_ship() -> void:
	if ship != null:
		ship.queue_free()
	ship = Ship.new().createBasic(camera_3d, projectiles)
	arrow.ship = ship
	add_child(ship)
	ship.connect("ship_died", _on_ship_died)
	mission_manager._finish_mission()
	death_scene.visible = false
	start_scene.visible = false
	mission_manager.ship = ship
	asteroid_manager.ship = ship
