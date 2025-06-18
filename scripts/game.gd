extends Node3D

@onready var lasers: Node = $Lasers
@onready var ship: Node = $Ship

func _on_player_hit():
	print("SUI")

func _ready():
	ship.player_hit.connect(_on_player_hit)

func _on_player_laser_shot(laser):
	lasers.add_child(laser)
