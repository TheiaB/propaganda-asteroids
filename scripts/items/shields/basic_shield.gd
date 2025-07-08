extends Shield

@export var health := 20


func _ready() -> void:
	shield_health = health
	title = "Shield"
	description = "Shields you"
	buyable = true
