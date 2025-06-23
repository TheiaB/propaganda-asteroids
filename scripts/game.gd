extends Node3D

@onready var lasers: Node = $Lasers
@onready var ship: Node = $Ship

func _ready():
	pass
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)
	
