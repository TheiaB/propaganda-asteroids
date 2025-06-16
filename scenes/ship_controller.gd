extends CharacterBody3D

@export var ACCELERATION := 0.5
@export var MAX_SPEED := 10.0
@export var ROTATION_SPEED := 1.5

func _physics_process(delta):
	# Handle rotation
	if Input.is_action_pressed("left"):
		rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-ROTATION_SPEED * delta)

	# Handle forward/backward input
	var input_z := Input.get_axis("break", "gas")  # "gas" is forward
	var direction := Vector3(0, 0, -input_z)

	# Transform local direction to global
	direction = global_transform.basis * direction
	direction.y = 0  # prevent upward/downward movement

	# Accelerate towards the desired velocity
	velocity = velocity.move_toward(direction.normalized() * MAX_SPEED, ACCELERATION)

	# Move the character
	move_and_slide()
