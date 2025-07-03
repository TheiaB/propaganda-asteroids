@tool
extends GridContainer

var all_items:Array[Item]
@onready var template_panel: ItemPanel = $ItemPanel  # the original one


@export_tool_button("Init Grid", "Callable") var init_action = init_grid
func init_grid():
	all_items = GlobalItemManager.get_all_items()
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	print('--- In Grid Container')
	for item_data in all_items:
		var panel = template_panel.duplicate()
		panel.visible = true
		panel.name = "ItemPanel_%s" % item_data.title  # Optional for debugging

		# Set item data (assumes these are exported on ItemPanel.gd)
		panel.visual 		= item_data.visual
		panel.visual3D 		= item_data.visual3D
		panel.title 		= item_data.title
		panel.price 		= item_data.price
		panel.description 	= item_data.description
		
		self.add_child(panel)
		print('added item: ',panel.title)
	print('--- After Grid Container')


func _ready() -> void:
	if not Engine.is_editor_hint():
		init_grid()
