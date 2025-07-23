extends Generic_Item

@export var MAX_SPEED := 300

#func _ready() -> void:
	
func load_attributes(ship: Ship):
	ship.stats.MAX_SPEED = MAX_SPEED
	ship.stats.ROTATION_SPEED = 30.0
