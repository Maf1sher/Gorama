@abstract
class_name SocketPanel
extends TextureRect

var item: InventoryItem
var socket: Socket

func _ready() -> void:
	set_item()

@abstract
func set_item() -> void
