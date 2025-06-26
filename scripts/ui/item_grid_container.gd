@tool
extends GridContainer

var all_items:Array[Item]

const ITEM_PANEL = preload("res://scenes/ui/item_panel.tscn")

@export_tool_button("Init Grid", "Callable") var init_action = init_grid
func init_grid():
	all_items = GlobalItemManager.get_all_items()
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	print('--- In Grid Container')
	for item in all_items:
		var item_instance = ITEM_PANEL.instantiate()
		
		item_instance.item = item
		item_instance.visual 		= item.visual
		item_instance.visual3D 		= item.visual3D
		item_instance.title 		= item.title
		item_instance.price 		= item.price
		item_instance.description 	= item.description
		
		self.add_child(item_instance)
		print('added item: ',item.title)
	print('--- After Grid Container')


func _ready() -> void:
	if not Engine.is_editor_hint():
		init_grid()
