extends Node3D
class_name Cargo
@onready var container: MeshInstance3D = $CONTAINER1_002
@onready var material:StandardMaterial3D
@export var textures:Array[Resource]

func _ready():
	container = get_child(0)
	material = container.get_active_material(0)

func random_texture():
	material.albedo_texture = textures.pick_random()
