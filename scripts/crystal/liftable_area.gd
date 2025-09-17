extends Area2D
	
@export var item_name: String

func pick_up_item() -> String:
	get_parent().queue_free()
	return item_name
