#@tool
extends Zone
class_name ZonePlanet

@export var unique_name: String
@export var health :int= 3
@export var rotation_speed :float= -0.05

@export var planet_iterations:Array[Node3D]
var current_planet_iteration:Node3D

#@export_tool_button("Hurt Me Mommy", "Callable") var hurt_planet = hurt
func hurt() -> void:
	modify_health(-1)

func modify_health(amount:int = -1):
	print('---health ',name, ' ',health)
	health += amount
	if(planet_iterations.size()>0):
		for planet in planet_iterations:
			planet.hide()
		if(health > planet_iterations.size()):
			# health 4+ on planet 0
			current_planet_iteration = planet_iterations[0]
			print('---more health than necessary')
		elif(health < 1):
			# health 0- on planet 2
			print('---less health than necessary')
			current_planet_iteration = planet_iterations[planet_iterations.size() - 1]
		else:
			# maps
			# health 3 on planet 0
			# health 2 on planet 1
			# health 1 on planet 2
			print('---health ',health)
			current_planet_iteration = planet_iterations[planet_iterations.size() - health]
		current_planet_iteration.show()
		return


func _ready():
	if(planet_iterations.size()>0):
		modify_health(0)

func _process(delta: float) -> void:
	current_planet_iteration.rotate_y(rotation_speed * delta)

func _on_zone_area_body_exited(body: Node3D) -> void:
	if (body is Asteroid):
		var asteroid = body as Asteroid
		asteroid.enable()
