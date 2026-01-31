#@tool
extends GridContainer

class_name ShopGrid

var all_items:Array[Item]
@onready var item_panel_scene: PackedScene = preload("res://scenes/ui/item_panel.tscn")

signal panel_buy_pressed(item:Item)

func init_grid(ship: Ship):
	print("initializing grid")

	all_items = GlobalItemManager.get_all_items()
	GlobalItemManager.sort_by_prize(all_items)

	for child in self.get_children():
		child.queue_free()

	for item_data in all_items:

		if !item_data.buyable() or !item_data.in_stock:
			continue

		if item_data is Shield:
			if ship.shield != null && ship.shield.shield_health > 1:
				if item_data.shield_health == ship.shield.shield_health:
					continue
		if ship && ship.items.has(item_data):
			continue

		var panel: ItemPanel = item_panel_scene.instantiate()
#		panel.item = item_data
		panel.visible = true

		panel.title        = item_data.title
		panel.price        = item_data.price
		panel.description  = item_data.description
		panel.presentation_video = item_data.video
		#panel.in_stock     = item_data.in_stock

		panel.buy_button_pressed.connect(
			_on_panel_buy_pressed.bind(item_data)
		)

		self.add_child(panel)


#func init_grid():
	#print("initializing grid")
	#all_items = GlobalItemManager.get_all_items()
	#GlobalItemManager.sort_by_prize(all_items)
	#for n in self.get_children():
		#n.queue_free()
	#for item_data in all_items:
		#
		#if !item_data.buyable() or !item_data.in_stock:
			#continue
		#if item_data is Shield:
			#var ship_shield_health = GlobalShipManager.get_ship_shield_health()
			#var in_stock_shields = GlobalItemManager.get_in_stock_shields(ship_shield_health)
			#if in_stock_shields.has(item_data) == false:
				#continue
			#
		#var panel: ItemPanel = item_panel_scene.instantiate() 
		#panel.visible = true
		#
		#panel.title 		= item_data.title
		#panel.price 		= item_data.price
		#panel.description 	= item_data.description
		#panel.presentation_video = item_data.video
		#panel.unique_name = item_data.unique_name
		#panel.in_stock = item_data.in_stock
		#
		#panel.buy_button_pressed.connect(_on_panel_buy_pressed.bind(item_data))
#
		#self.add_child(panel)
		#
		#
		#


#func update_grid():
	#for n in self.get_children():
		#if n is Panel:
			#if !n.in_stock:
				#n.visible = false
			#for item in GlobalShipManager.ship.items:
				#if n.unique_name == item.unique_name:
					#n.visible = false

func _on_panel_buy_pressed(item:Item):
	SoundManager5000.menu_open_sfx.play_one_shot()
	emit_signal("panel_buy_pressed", item)

func _ready() -> void:
	pass
	#if not Engine.is_editor_hint():
		#init_grid()
