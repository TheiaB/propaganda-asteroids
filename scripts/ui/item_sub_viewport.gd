extends SubViewport

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _gui_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mesh.rotation_degrees.y += event.relative.x * 0.5
		mesh.rotation_degrees.x += event.relative.y * 0.5
		
@onready var pivot: Marker3D = $Pivot

func _process(delta: float) -> void:
	pivot.rotate_y(1.0 * delta)
