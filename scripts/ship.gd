extends CharacterBody3D

@export var ACCELERATION := 2.0
@export var DECELERATION := 0.0
@export var MAX_SPEED := 5.0
@export var ROTATION_SPEED := 1.5

#TODO: Variablesa
# MIN_SPEED_THRESHOLD

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-ROTATION_SPEED * delta)

	var input_vector = Vector3(0, 0, -Input.get_axis("break", "gas"))

	if input_vector != Vector3.ZERO:
		input_vector = input_vector.normalized()
		var direction = (global_transform.basis * input_vector)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, DECELERATION * delta)

	move_and_slide()
