extends Node

class_name TimerManager

@onready var asteroid_timer: Timer = $AsteroidTimer
@onready var fuel_timer: Timer = $FuelTimer

func startAsteroid() -> void:
	asteroid_timer.start()
	
func stopAsteroid() -> void:
	asteroid_timer.stop()

func startFuel() -> void:
	fuel_timer.start()
	
func stopFuel() -> void:
	fuel_timer.stop()

func startAll() -> void:
	asteroid_timer.start()
	fuel_timer.start()
	
func stopAll() -> void:
	asteroid_timer.stop()
	fuel_timer.stop()
