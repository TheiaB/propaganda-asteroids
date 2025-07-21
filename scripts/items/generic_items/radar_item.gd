extends Generic_Item

func _ready() -> void:
	pass
	
func on_equip():
	GlobalCameraManager.camera.offset.y += 5

func on_unequip():
	GlobalCameraManager.camera.offset.y -= 5

func buyable():
	var zone_planet_1_health : ZonePlanet = ZoneManager.get_planet_by_enum(ZoneManager.Planets.PLANET_WATER)

	print("zone_planet_1_heath: ", zone_planet_1_health.health)
	return true
