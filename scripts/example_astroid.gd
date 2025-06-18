extends Area3D

signal ship_hits_astroid
@onready var ship: CharacterBody3D = %Ship
@export var health = 3

func _on_area_entered(area: Area3D) -> void:
	health -= ship.weapon_damage
	if health <= 0:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	ship_hits_astroid.emit()
	
	
