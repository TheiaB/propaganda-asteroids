extends Node3D
class_name Zone

signal player_entered(zone)


func _on_player_enter_zone(body: Node3D) -> void:
	player_entered.emit(self)
