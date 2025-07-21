extends Node

class_name Item

@export var title:String = "DEFAULT ITEM TITLE"
@export var price:int = 50
@export var description:String = "DEFAULT ITEM DESCRIPTION"
@export var video:VideoStream
@export var unique_name:String = ""
@export_multiline var legal_text:String = """[b]no text[/b
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]
											[b]no text[/b]"""


@export var in_stock = true

var camera : Player_Camera

func on_equip():
	pass

func on_unequip():
	pass

func buyable():
	return true
