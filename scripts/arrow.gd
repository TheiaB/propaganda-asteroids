extends MeshInstance3D
class_name Arrow3D

var destination_position:Vector3

var ship: Ship

var direction:Vector2
var angle:float

func _process(_delta: float) -> void:
	if ship:
		direction = Vector2(destination_position[0],destination_position[2]) - Vector2(ship.position[0],ship.position[2])
	else:
		direction = Vector2(destination_position[0],destination_position[2]) - Vector2(0, 0)
	
	angle = rad_to_deg(direction.angle_to(Vector2(1,0)))	
	set_rotation_degrees(Vector3(0,0,angle))
	
	pass
