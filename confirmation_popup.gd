extends PopupPanel

@onready var accept_button: Button = $VBoxContainer/AcceptButton
@onready var scroll_container: ScrollContainer = $VBoxContainer/ScrollContainer
@onready var legal_text: RichTextLabel = $VBoxContainer/ScrollContainer/LegalText

var item_data  # Optional: store the item info if needed
signal terms_accepted(item_title : String)

func _ready():
	accept_button.disabled = true
	visible = false
	legal_text.scroll_active = true
	scroll_container.get_v_scroll_bar().value_changed.connect(_on_scroll_check)

func show_popup(item: Item):
	accept_button.disabled = true
	item_data = item
	legal_text.text = item_data.legal_text
	legal_text.scroll_active = true
	scroll_container.get_v_scroll_bar().value = 0
	accept_button.disabled = true
	show()
	popup_centered()
	_on_scroll_check(scroll_container.get_v_scroll_bar().value)
	
		
func _on_scroll_check(value: float) -> void:
	if can_accept(value):
		accept_button.disabled = false
		print("disabled button")
	else:
		accept_button.disabled = true
		print("enabled button")
	#var scrollbar = scroll_container.get_v_scroll_bar()
	#if scrollbar.value >=  scrollbar.max_value - scrollbar.page - 5 or legal_text.get_content_height() < scrollbar.max_value:
		#accept_button.disabled = false

func can_accept(value: float) -> bool:
	var scrollbar = scroll_container.get_v_scroll_bar()
	var at_bottom = value >= scrollbar.max_value - scrollbar.page - 1
	var short_text = legal_text.get_content_height() < scrollbar.max_value
	if at_bottom || short_text:
		return true
	return false

func _on_accept_button_pressed() -> void:
	print("Accepted conditions for item: ", item_data.unique_name)
	hide()
	emit_signal('terms_accepted', item_data.unique_name)
