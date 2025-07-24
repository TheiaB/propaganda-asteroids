extends Label

var game : Game

func _process(_delta: float) -> void:
	text = str(GlobalMoneyManager.resource_money)
