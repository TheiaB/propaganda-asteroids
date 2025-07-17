extends Generic_Active_Item

@export var cost : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 50
	title = "Active Shield"
	buyable = true
	description = "Use this shield in the right moment. \n" 
	description += "To protect yourself from harm. \n For the low cost of only 1$"
	cost = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
