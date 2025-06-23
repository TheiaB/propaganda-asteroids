extends Generic_Item

@export var MAX_SPEED := 100
	
func load_attributes(ship: Ship):
	ship.stats.MAX_SPEED = MAX_SPEED
