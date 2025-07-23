extends Node3D
class_name Menu3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("space_rotation")
	$ship/ThrusterSpriteRight.play("thruster_loop")
	$ship/ThrusterSpriteLeft.play("thruster_loop")
