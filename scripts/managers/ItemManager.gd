@tool
extends Node

class_name ItemManager

var weapons : Array[Weapon]
var shields : Array[Shield]
var generic_items : Array[Generic_Item]
var active_items : Array[Generic_Active_Item]

var player_camera : Player_Camera

func _ready() -> void:
	instantiate_all_in_path("res://scenes/items/weapons/", weapons)
	instantiate_all_in_path("res://scenes/items/shields/", shields)
	instantiate_all_in_path("res://scenes/items/generic_items/", generic_items)
	instantiate_all_in_path("res://scenes/items/active_items/", active_items)


func find(unique_name:String):
	for item in get_all_items():
		if item.unique_name == unique_name:
			return item
	
func instantiate_all_in_path(path, array):
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var obj = load(path + file_name)
		if obj:
			var item:Item = obj.instantiate()
			add_child(item)
			array.append(item)
		file_name = dir.get_next()
		

func get_all_weapons() -> Array[Weapon]:
	return weapons
	
func get_all_shields() -> Array[Shield]:
	return shields

func get_all_generic_items()-> Array[Generic_Item]:
	return generic_items
	
func get_all_active_items() -> Array[Generic_Active_Item]:
	return active_items

func get_all_items()-> Array[Item]:
	var all_items:Array[Item]
	all_items.append_array(shields)
	all_items.append_array(weapons)
	all_items.append_array(generic_items)
	all_items.append_array(active_items)
	#maybe sort by price???
	return all_items
	
func sort_by_prize(items : Array[Item]) -> void:
	items.sort_custom(func(a, b): return a.price < b.price)
	
func get_item(title : String):
	for item in get_all_items():
		if item.title == title:
			return item
	push_error("Item not found!")
	
func get_rand_item() -> Item:
	return get_all_items().pick_random()
	
