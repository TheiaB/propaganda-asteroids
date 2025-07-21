extends Zone
class_name ZonePlanet

@export var unique_name: String
@export var health :int= 3

@export var planet_iterations:Array[Node3D]

func modify_health(amount:int):
	health + amount
	print('---health ',health)
	for planet in planet_iterations:
		planet.hide()
	if(health > planet_iterations.size()):
		# health 4 on planet 0
		planet_iterations[0].show()
		print('---more health than necessary')
	elif(health < 1):
		# health 0 on planet 2
		print('---less health than necessary')
		planet_iterations[planet_iterations.size() - 1].show()
	else:
		# maps
		# health 3 on planet 0
		# health 2 on planet 1
		# health 1 on planet 2
		print('---health ',health)
		planet_iterations[planet_iterations.size() - health].show()
	pass


func _ready():
	if(planet_iterations.size()>0):
		modify_health(0)
