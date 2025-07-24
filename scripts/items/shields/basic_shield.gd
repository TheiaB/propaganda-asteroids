extends Shield

@export var health := 1
@export var start_health : int

func _ready() -> void:
	shield_health = health
	start_health = health
	
