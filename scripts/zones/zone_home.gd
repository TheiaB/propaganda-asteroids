extends Zone
class_name ZoneHome

@onready var park_here_marker_3d: Marker3D = $ParkHereMarker3D

func _on_zone_proximity_body_exited(_body: Node3D) -> void:
	pass # Replace with function body.
