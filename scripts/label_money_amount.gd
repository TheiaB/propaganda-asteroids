extends Label

var game : Game

func _process(_delta: float) -> void:
	text = str(game.resource_money)
