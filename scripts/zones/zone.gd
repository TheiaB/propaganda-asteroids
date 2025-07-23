extends Node3D
class_name Zone

signal proximity_entered(zone)
signal player_entered(zone)
signal proximity_exited()

@onready var zone_area: Area3D = $ZoneArea


func _on_body_enter_zone(_body: Node3D) -> void:
	#var layer:int= _body.get_collision_layer()
	#print(layer)
	#if(layer == 2):
	if(_body is Ship):
		player_entered.emit(self)
	elif(_body is Asteroid):
		var asteroid:Asteroid = _body
		asteroid.destroy_me()
	else:
		print('this collided: ',_body.get_class())
		


func _on_zone_proximity_body_entered(_body: Node3D) -> void:
	#To be used for music change and spawning planet asteroids
	proximity_entered.emit(self)


func _on_zone_proximity_body_exited(_body: Node3D) -> void:
	proximity_exited.emit()
	
