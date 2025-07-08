extends Generic_Item

@export var MAX_SPEED := 300

func _ready() -> void:
	buyable = true
	title = 'Passive Speed Boost'
	#TODO desc
	
func load_attributes(ship: Ship):
	ship.stats.MAX_SPEED = MAX_SPEED
	ship.stats.ROTATION_SPEED = 30.0
