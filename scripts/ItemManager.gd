@tool
extends Node

class_name ItemManager

var weapons : Array[Weapon]
var shields : Array[Shield]
var generic_items : Array[Generic_Item]

func _ready() -> void:
	instantiate_all_in_path("res://scenes/items/weapons/", weapons)
	instantiate_all_in_path("res://scenes/items/shields/", shields)
	instantiate_all_in_path("res://scenes/items/generic_items/", generic_items)
	
func instantiate_all_in_path(path, array):
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var obj = load(path + file_name)
		if obj:
			var item = obj.instantiate()
			add_child(item)
			array.append(item)
		file_name = dir.get_next()
		

func get_all_weapons() -> Array[Weapon]:
	return weapons
	
func get_all_shields() -> Array[Shield]:
	return shields

func get_all_generic_items()-> Array[Generic_Item]:
	return generic_items

func get_all_items()-> Array[Item]:
	var all_items:Array[Item]
	all_items.append_array(shields)
	all_items.append_array(weapons)
	all_items.append_array(generic_items)
	#maybe sort by price???
	return all_items
