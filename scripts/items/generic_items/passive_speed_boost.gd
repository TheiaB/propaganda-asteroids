extends Generic_Item

@export var MAX_SPEED := 9.8
@export var ACCELERATION := 5.0
@export var ROTATION_SPEED := 3.0

#func _ready() -> void:
	
func load_attributes(ship: Ship):
	print("loaded boost attributes")
	ship.stats.MAX_SPEED = MAX_SPEED
	ship.stats.ACCELERATION = ACCELERATION
	ship.stats.ROTATION_SPEED = ROTATION_SPEED
