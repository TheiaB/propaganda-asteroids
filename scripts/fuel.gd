extends HSlider

@export var game: Game

func _process(_delta: float) -> void:
	self.value = game.resource_fuel
