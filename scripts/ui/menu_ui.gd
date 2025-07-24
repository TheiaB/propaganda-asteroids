
extends CanvasLayer
class_name Menu_Control


signal menu_open
signal menu_close
signal menu_restart
signal esc

@onready var menu_3d: Menu3D = $Menu3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var credits: Control = $Credits
@onready var transition_timer: Timer = $TransitionTimer

@onready var sub_viewport: SubViewport = $Menu3D/SubViewport
@onready var menu_background: TextureRect = $MenuBackground

func _ready():
	connect("menu_open", open_menu)
	var viewportText:ViewportTexture = menu_background.texture
	viewportText.viewport_path = sub_viewport.get_path()
	SoundManager5000.music_gamestart.play()
	

	

func _on_button_play_pressed() -> void:
	print("play!")
	close_menu()
	emit_signal("menu_close")
	pass # Replace with function body.

func _on_button_reset_pressed() -> void:
	#emit_signal("menu_restart")
	#menu_restart.emit.call_deferred(5.0)
	animation_player.play("fade_to_black")
	await get_tree().create_timer(transition_timer.wait_time).timeout; menu_restart.emit()
	#close_menu()
	# Replace with function body.
	#open_menu()
	

func _on_button_credits_pressed() -> void:
	credits.show()
	pass # Replace with function body.
func _on_button_exit_credits_pressed() -> void:
	credits.hide()
	pass # Replace with function body.




func _on_button_debug_pressed() -> void:
	pass # Replace with function body.

func open_menu():
	animation_player.play_backwards("fade_to_black")
	print("open menu")
	show()
	menu_3d.show()
	pass

func close_menu():
	hide()
	menu_3d.hide()
	
func _input(event):
	if event.is_action_pressed("menu"):
		print("Menu: Esc!")
		emit_signal("esc")
