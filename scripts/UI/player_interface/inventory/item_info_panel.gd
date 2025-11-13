extends PopupPanel

@onready var effect_sceen = preload("res://scenes/UI/select_card/effect.tscn")
@onready var socket_layer_sceen = preload("res://scenes/UI/player_interface/item_info_panel/socket_layer_panel.tscn")
@onready var socket_sceen = preload("res://scenes/UI/player_interface/item_info_panel/socket.tscn")

@onready var effects_container = $Control/MarginContainer/VBoxContainer/EffectsContainer
@onready var sockets_container = $Control/MarginContainer/VBoxContainer/SocketContainer

var data: ItemData = null

var socket_map: Dictionary = {}

func set_data(item_data: ItemData) -> void:
	data = item_data
	var stats := data.stats.get_modified_stats()
	for stat in stats:
		var new_effect = effect_sceen.instantiate()
		new_effect.set_effect_text(stat, stats[stat])
		effects_container.add_child(new_effect)
	
	#sockets_container.generate_socket_tree(data.socket_layers)

func _on_about_to_popup() -> void:
	sockets_container.generate_socket_tree(data.socket_layers)

func _on_popup_hide() -> void:
	sockets_container.clear_socket_tree()
