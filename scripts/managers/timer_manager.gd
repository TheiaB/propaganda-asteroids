extends Node

class_name TimerManager

@onready var fuel_timer: Timer = $FuelTimer
@onready var active_item_money_timer : Timer = $ActiveItemMoneyTimer

func startFuel() -> void:
	fuel_timer.start()
	
func stopFuel() -> void:
	fuel_timer.stop()
	
func startActive() -> void:
	active_item_money_timer.start()
	
func stopActive() -> void:
	active_item_money_timer.stop()

func startAll() -> void:
	fuel_timer.start()
	
func stopAll() -> void:
	fuel_timer.stop()
