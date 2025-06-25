@tool
extends Panel
class_name ItemPanel

@export var visual:Texture2D
@export var visual3D:Mesh
@export var title:String
@export var price:int
@export var description:String

@onready var texture_item: TextureRect = $VBoxContainer/TextureRect

@onready var label_title: Label = $VBoxContainer/HBoxContainer/LabelTitle
@onready var label_price: Label = $VBoxContainer/HBoxContainer/LabelPrice


func _ready() -> void:
	update_item()
	pass

func update_item():
	if(visual != null):
		texture_item.texture = visual
	if(title != null):
		label_title.text = title
	if(price != null):
		label_price.text = str(price)
	

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		pass


func _on_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
