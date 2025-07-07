extends Node


var basic_button_sfx: FmodEvent = null
var menu_open_sfx: FmodEvent = null
var laser_basic_sfx: FmodEventEmitter3D = null


func _ready():
	basic_button_sfx = FmodServer.create_event_instance("event:/UI_Sounds/BasicButton")
	menu_open_sfx = FmodServer.create_event_instance("event:/UI_Sounds/OpenMenu")
	laser_basic_sfx = $LaserBasic
func play_sound(sound: FmodEventEmitter3D):
	sound.play()
	
func play_sound_pos(node: Node, sound: FmodEventEmitter3D):
	sound.global_position = node.global_position
	sound.play()
