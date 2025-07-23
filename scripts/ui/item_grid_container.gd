@tool
extends GridContainer

class_name ShopGrid

var all_items:Array[Item]
@onready var item_panel_scene: PackedScene = preload("res://scenes/ui/item_panel.tscn")

signal panel_buy_pressed(item:Item)

func init_grid():
	all_items = GlobalItemManager.get_all_items()
	print(all_items)
	GlobalItemManager.sort_by_prize(all_items)
	for n in self.get_children():
		n.queue_free()
	for item_data in all_items:
		
		if !item_data.buyable() or !item_data.in_stock:
			continue
		var panel: ItemPanel = item_panel_scene.instantiate() 
		panel.visible = true
		
		panel.title 		= item_data.title
		panel.price 		= item_data.price
		panel.description 	= item_data.description
		panel.presentation_video = item_data.video
		
		panel.buy_button_pressed.connect(_on_panel_buy_pressed.bind(item_data))

		self.add_child(panel)
		

func _on_panel_buy_pressed(item:Item):
	SoundManager5000.menu_open_sfx.play_one_shot()
	emit_signal("panel_buy_pressed", item)

func _ready() -> void:
	if not Engine.is_editor_hint():
		init_grid()
