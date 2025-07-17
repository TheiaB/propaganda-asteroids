extends Shield

@export var health := 1


func _ready() -> void:
	shield_health = health
	title = "Shield"
	description = "Shields you"
	buyable = true
