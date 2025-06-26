extends Node

class_name UIManager

@onready var death_scene: Node2D = $death_scene
@onready var start_scene: Node2D = $start_scene

func setUI(ui_name: String = ""):
	death_scene.visible = false
	start_scene.visible = false
	if ui_name == "death_scene":
		death_scene.visible = true
	
	if ui_name == "start_scene":
		start_scene.visible = false
