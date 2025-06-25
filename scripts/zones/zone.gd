extends Node3D
class_name Zone

signal proximity_entered(zone)
signal player_entered(zone)
signal proximity_exited()


func _on_player_enter_zone(_body: Node3D) -> void:
	player_entered.emit(self)


func _on_zone_proximity_body_entered(_body: Node3D) -> void:
	#To be used for music change and spawning planet asteroids
	proximity_entered.emit(self)


func _on_zone_proximity_body_exited(body: Node3D) -> void:
	proximity_exited.emit()
