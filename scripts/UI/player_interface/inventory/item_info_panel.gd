extends PopupPanel

@onready var effect_sceen = preload("res://scenes/UI/select_card/effect.tscn")
@onready var socket_layer_sceen = preload("res://scenes/UI/player_interface/item_info_panel/socket_layer_panel.tscn")
@onready var socket_sceen = preload("res://scenes/UI/player_interface/item_info_panel/socket_panel.tscn")

@onready var effects_container = $Control/TextureRect/MarginContainer/EffectsContainer
@onready var sockets_container = $Control/TextureRect/MarginContainer/SocketContainer

var data: ItemData = null

var socket_map: Dictionary = {}

func set_data(item_data: ItemData) -> void:
	data = item_data
	var stats := data.stats.get_modified_stats()
	for stat in stats:
		var new_effect = effect_sceen.instantiate()
		new_effect.set_effect_text(stat, stats[stat])
		effects_container.add_child(new_effect)
	
	sockets_container.generate_socket_tree(data.socket_layers)
