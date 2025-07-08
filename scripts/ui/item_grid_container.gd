@tool
extends GridContainer

var all_items:Array[Item]
@onready var template_panel: ItemPanel = $ItemPanel
#@export var item_panel_scene: PackedScene = preload("res://scenes/ui/item_panel.tscn")



@export_tool_button("Init Grid", "Callable") var init_action = init_grid
func init_grid():
	all_items = GlobalItemManager.get_all_items()
	var template = template_panel
	for n in self.get_children():
		if n != template:
			self.remove_child(n)
			n.queue_free()
	print('--- In Grid Container')
	for item_data in all_items:
		if !item_data.buyable:
			continue
		#var panel = item_panel_scene.instantiate()  # Use PackedScene now
		#panel.name = "ItemPanel_%s" % item_data.title
		#panel.visible = true
		var panel = template.duplicate()
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
		
	self.remove_child(template)
	#template.queue_free()
	print('--- After Grid Container')


func _ready() -> void:
	if not Engine.is_editor_hint():
		init_grid()
