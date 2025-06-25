extends Node

class_name ItemManager

static func get_all_weapons():
	var dir = DirAccess.open("res://scenes/items/weapons")
	print(dir.list_dir_begin())
	return dir.get_next()
