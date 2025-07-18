extends Generic_Item

func _ready() -> void:
	pass
	
func on_equip():
	GlobalCameraManager.camera.offset.y += 5

func on_unequip():
	GlobalCameraManager.camera.offset.y -= 5

func buyable():
	var zone_planet_1_health = ZoneManager.get_planet_by_enum(ZoneManager.Planets.zone_planet_1).health
	print("zone_planet_1_heath: ", zone_planet_1_health)
	return true
