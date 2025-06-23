extends CharacterStats

@export var acc := 4.0
@export var decc := 0.3
@export var max_speed := 13.0
@export var rotation_speed := 5.9
@export var min_speed_threshold := 5.0
@export var decc_after_threshold := 0.1

func load_attributes(ship: Ship):
	ACCELERATION = acc
	DECELERATION = decc
	MAX_SPEED = max_speed
	ROTATION_SPEED = rotation_speed
	MIN_SPEED_THRESHOLD = min_speed_threshold
	DECELERATION_AFTER_THRESHOLD = decc_after_threshold
