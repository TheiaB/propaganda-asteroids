extends CanvasLayer
class_name ShopMissionInterface

@onready var game: Game = %Game
@onready var shop: TabBar = $TabContainer/Shop
@onready var missions: TabBar = $TabContainer/Mission


signal start_mission

func _ready():
	game = get_tree().get_root().get_node("Game")

func open_missions() -> void:
	self.show()
	missions.show()
	pass


func open_shop() -> void:
	self.show()
	shop.show()
	pass


func close_all() -> void:
	self.hide()
	pass



func _on_mission_start_button_pressed() -> void:
	emit_signal("start_mission")
	pass
