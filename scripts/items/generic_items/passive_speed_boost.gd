extends Generic_Item

@export var MAX_SPEED := 20
@export var acc := 9.0

#func _ready() -> void:
	
func load_attributes(ship: Ship):
	print("loaded boost attributes")
	ship.stats.MAX_SPEED = MAX_SPEED
	ship.stats.ACCELERATION = acc
	ship.stats.ROTATION_SPEED = 6.0
