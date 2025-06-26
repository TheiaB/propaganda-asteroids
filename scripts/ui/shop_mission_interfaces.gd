extends CanvasLayer

@onready var game: Game = %Game
@onready var shop: TabBar = $TabContainer/Shop
@onready var missions: TabBar = $TabContainer/Mission

func _ready():
	game = get_tree().get_root().get_node("Game")
	#game.open_missions.connect(_open_missions)
	#game.open_shop.connect(_open_shop)
	#game.close_shop_missions.connect(_close)

func _on_game_open_missions() -> void:
	self.show()
	missions.show()
	pass


func _on_game_open_shop() -> void:
	self.show()
	shop.show()
	pass


func _on_game_close_shop_missions() -> void:
	self.hide()
	pass


func _on_mission_start_button_pressed() -> void:
	game.close_shop_missions.emit()
	game.start_mission.emit()
	pass # Replace with function body.
