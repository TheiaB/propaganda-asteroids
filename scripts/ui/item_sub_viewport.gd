extends SubViewport
		
@onready var pivot: Marker3D = $Pivot

func _process(delta: float) -> void:
	pivot.rotate_y(1.0 * delta)
