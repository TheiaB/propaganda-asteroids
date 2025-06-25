extends Node

class_name ItemManager

static func get_all_items():
	var dir = DirAccess.open("scenes")
	print(dir)
