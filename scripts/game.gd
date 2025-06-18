extends Node3D

@onready var lasers: Node = $Lasers
@onready var ship: Node = $Ship
@onready var example_astroid = $Astroid

func _on_player_hit_static_body():
	print("Ship hit static body")
	
	
func _on_ship_hits_astroid():
	print("Ship hits Astroid")

func _ready():
	ship.player_hit_static_body.connect(_on_player_hit_static_body)
	example_astroid.ship_hits_astroid.connect(_on_ship_hits_astroid)
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)
	
