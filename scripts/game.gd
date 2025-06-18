extends Node3D

func _on_player_hit():
	print("SUI")

func _ready():
	var ship = $Ship
	ship.player_hit.connect(_on_player_hit)
