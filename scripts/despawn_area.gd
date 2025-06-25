extends Area3D


var camera: Camera3D

func _ready():
	camera = get_node("../../Camera3D")

func _process(_delta):
	if camera:
		global_transform.origin = camera.global_transform.origin
