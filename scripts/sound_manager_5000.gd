extends Node

func play_sound(sound: FmodEventEmitter3D):
	sound.play()
	
func play_sound_pos(node: Node, sound: FmodEventEmitter3D):
	sound.global_position = node.global_position
	sound.play()
