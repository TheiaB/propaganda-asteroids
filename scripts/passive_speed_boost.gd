extends Generic_Item

@export var MAX_SPEED := 300
	
func load_attributes(ship: Ship):
	ship.stats.MAX_SPEED = MAX_SPEED
	ship.stats.ROTATION_SPEED = 30.0
	ship.stats.get_physics_process_delta_time()
