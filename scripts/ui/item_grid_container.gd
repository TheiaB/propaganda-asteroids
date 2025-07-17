@tool
extends GridContainer

var all_items:Array[Item]
@onready var item_panel_scene: PackedScene = preload("res://scenes/ui/item_panel.tscn")

signal panel_buy_pressed(item:Item)

#@export_tool_button("Init Grid", "Callable") var init_action = init_grid
func init_grid():
	all_items = GlobalItemManager.get_all_items()
	GlobalItemManager.sort_by_prize(all_items)
	for n in self.get_children():
		n.queue_free()
	print('--- In Grid Container')
	for item_data in all_items:
		if !item_data.buyable:
			continue
		var panel: ItemPanel = item_panel_scene.instantiate() 
		panel.visible = true
		
		panel.title 		= item_data.title
		panel.price 		= item_data.price
		panel.description 	= item_data.description
		panel.presentation_video = item_data.video
		
		panel.buy_button_pressed.connect(_on_panel_buy_pressed.bind(item_data))

		self.add_child(panel)
		print('added item: ',panel.title)
		
	print('--- After Grid Container')

func _on_panel_buy_pressed(item:Item):
	emit_signal("panel_buy_pressed", item)

func _ready() -> void:
	if not Engine.is_editor_hint():
		init_grid()
