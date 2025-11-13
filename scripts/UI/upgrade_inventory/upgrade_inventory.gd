extends Control

@onready var socket_container = $HBoxContainer/SocketPanel/MarginContainer/SocketContainer

func _on_character_sheet_slot_item_changed(item: InventoryItem) -> void:
	if item:
		socket_container.generate_socket_tree(item.data.socket_layers)
	else:
		socket_container.clear_socket_tree()
