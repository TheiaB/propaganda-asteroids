extends Node

class_name TimerManager

@onready var fuel_timer: Timer = $FuelTimer

func startFuel() -> void:
	fuel_timer.start()
	
func stopFuel() -> void:
	fuel_timer.stop()

func startAll() -> void:
	fuel_timer.start()
	
func stopAll() -> void:
	fuel_timer.stop()
