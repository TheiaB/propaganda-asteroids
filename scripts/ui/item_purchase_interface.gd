@tool
extends Control

@export var visual3D:Mesh
@export var title:String
@export var price:int
@export var description:String

@onready var item_display_texture: TextureRect = $HBoxContainer/ItemPreview/TextureRect
@onready var item_sub_viewport: SubViewport = $HBoxContainer/ItemPreview/ItemSubViewport

@onready var item_mesh: MeshInstance3D = $HBoxContainer/ItemPreview/ItemSubViewport/Pivot/MeshInstance3D

@onready var item_title: Label = $HBoxContainer/ItemPreview/ItemTitle

@onready var item_description: RichTextLabel = $HBoxContainer/ItemDetails/RichTextLabel

@onready var item_buy_button: Button = $HBoxContainer/ItemDetails/Button


func _ready() -> void:
	update_item()


func update_item():
	print('updating item')
	if(visual3D != null):
		item_mesh.mesh = visual3D
		item_display_texture.texture = item_sub_viewport.get_texture()
	if(title != null):
		item_title.text = title
	if(description != null):
		item_description.text = description
	if(price != null):
		item_buy_button.text = "BUY FOR " + str(price) + "$"
