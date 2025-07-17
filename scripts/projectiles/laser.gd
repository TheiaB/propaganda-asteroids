extends Projectile

var initial_velocity
var bullet_direction
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	#initial_velocity = ship.velocity.normalized() * speed
	sprite.play("laser")

func _physics_process(delta: float) -> void:
	bullet_direction = -transform.basis.z
	#global_position += (bullet_direction + initial_velocity) * delta
	global_position += (bullet_direction).normalized() * speed * delta

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
