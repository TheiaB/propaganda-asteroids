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

func show_popup(item):
	item_data = item
	legal_text.text = _generate_legal_text()
	legal_text.scroll_active = true
	legal_text.scroll_to_line(0)
	accept_button.disabled = true
	visible = true
	show()
	popup_centered() 

func _generate_legal_text() -> String:
	var text = "Terms & Conditions:\n"
	for i in range(50):
		text += "This is a made-up legal clause #%d. " % i
		text += "You agree to not sue anyone even if this game takes your cat.\n"
	return text

		
func _on_scroll_check(value: float) -> void:
	var scrollbar = scroll_container.get_v_scroll_bar()
	if scrollbar.value >= scrollbar.max_value - scrollbar.page - 5:
		accept_button.disabled = false

func _on_accept_button_pressed() -> void:
	print("Accepted conditions for item: ", item_data.title)
	hide()
	emit_signal('terms_accepted', item_data.title)
