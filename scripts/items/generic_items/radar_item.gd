extends Generic_Item

func _ready() -> void:
	buyable = true
	
func on_equip():
	GlobalCameraManager.camera.offset.y += 5

func on_unequip():
	GlobalCameraManager.camera.offset.y -= 5
