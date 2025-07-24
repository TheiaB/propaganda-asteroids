#@tool
extends Zone
class_name ZonePlanet

@export var unique_name: String
@export var health :int= 3
@export var rotation_speed :float= -0.05

@export var planet_iterations:Array[Node3D]
var current_planet_iteration:Node3D

enum Planet {ANT, WATER, CRYSTAL, IRRELEVANT}

var current_news : Texture

var news = [
	{ "news": preload("res://assets/news/article_1.png"), "planet" : Planet.CRYSTAL},
	{ "news": preload("res://assets/news/article_2.png"), "planet": Planet.CRYSTAL},
	{ "news": preload("res://assets/news/article_3.png"), "planet": Planet.CRYSTAL},
	{ "news": preload("res://assets/news/article_4.png"), "planet": Planet.WATER},
	{ "news": preload("res://assets/news/article_5.png"), "planet": Planet.WATER},
	{ "news": preload("res://assets/news/article_6.png"), "planet": Planet.WATER},
	{ "news": preload("res://assets/news/article_7.png"), "planet": Planet.WATER},
	{ "news": preload("res://assets/news/article_8.png"), "planet": Planet.ANT},
	{ "news": preload("res://assets/news/article_9.png"), "planet" : Planet.ANT},
	{ "news": preload("res://assets/news/article_10.png"), "planet" : Planet.ANT}
]

#@export_tool_button("Hurt Me Mommy", "Callable") var hurt_planet = hurt
func hurt() -> void:
	modify_health(-1)
	
func get_news_ind() -> Vector2:
	if self.unique_name == 'antplanet':
		return Vector2(0,2)
	elif self.unique_name == 'waterplanet':
		return Vector2(3,6)
	else:
		return Vector2(7,9)

func modify_health(amount:int = -1):
	print('---health ',name, ' ',health)
	health += amount
	var news_index = get_news_ind()
	if(planet_iterations.size()>0):
		for planet in planet_iterations:
			planet.hide()
		if(health > planet_iterations.size()):
			# health 4+ on planet 0
			current_planet_iteration = planet_iterations[0]
			current_news = news[news_index.x].news
			print(news[news_index.x])
			print('---more health than necessary')
		elif(health < 1):
			# health 0- on planet 2
			print('---less health than necessary')
			current_news = news[news_index.y].news
			print(news_index.y)
			current_planet_iteration = planet_iterations[planet_iterations.size() - 1]
		else:
			# maps
			# health 3 on planet 0
			# health 2 on planet 1
			# health 1 on planet 2
			print('---health ',health)
			print(news[news_index.y - health].news)
			current_news = news[news_index.y + 1 - health].news
			print(news_index.y - health)
			current_planet_iteration = planet_iterations[planet_iterations.size() - health]
		current_planet_iteration.show()
		print(self.unique_name)
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
