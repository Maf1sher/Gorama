extends SocketPanel

@onready var item_graphic = $Item

func set_item() -> void:
	if socket and socket.item:
		item_graphic.texture = socket.item.texture
