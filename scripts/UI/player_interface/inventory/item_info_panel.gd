extends PopupPanel

@onready var effect_sceen: PackedScene = preload("res://scenes/UI/select_card/effect.tscn")
@onready var socket_layer_sceen: PackedScene = preload("res://scenes/UI/player_interface/item_info_panel/socket_layer_panel.tscn")
@onready var socket_sceen: PackedScene = preload("res://scenes/UI/player_interface/item_info_panel/socket.tscn")

@onready var effects_container_sceen: PackedScene = preload("res://scenes/UI/player_interface/item_info_panel/effects_container.tscn")
@onready var sockets_container_sceen: PackedScene = preload("res://scenes/UI/player_interface/item_info_panel/socket_container.tscn")
@onready var desciption_sceen: PackedScene = preload("res://scenes/UI/player_interface/item_info_panel/description.tscn")
@onready var line_drawer_sceen: PackedScene = preload("res://scenes/UI/player_interface/item_info_panel/line_drawer.tscn")

@onready var effects_container
@onready var sockets_container
@onready var description
@onready var line_drawer

@onready var item_details_container = $Control/MarginContainer/ItemDetailsContainer

var data: ItemData = null

var socket_map: Dictionary = {}

func _ready() -> void:
	effects_container = effects_container_sceen.instantiate()
	sockets_container = sockets_container_sceen.instantiate()
	description = desciption_sceen.instantiate()
	line_drawer = line_drawer_sceen.instantiate()
	_clear_details_container()

func set_data(item_data: ItemData) -> void:
	data = item_data
	if data is WeaponData:
		_set_socket_container()
		_set_effect_conteiner()
	elif data is EquipmentData:
		_set_effect_conteiner()
	elif data is UpgradeData:
		_set_description_container()
		
func _set_socket_container() -> void:
	item_details_container.add_child(sockets_container)
	item_details_container.add_child(line_drawer)

func _set_effect_conteiner() -> void:
	item_details_container.add_child(effects_container)
	var stats = data.stats.get_modified_stats()
	for stat in stats:
		var new_effect = effect_sceen.instantiate()
		new_effect.set_effect_text(stat, stats[stat])
		effects_container.add_child(new_effect)

func _set_description_container() -> void:
	item_details_container.add_child(description)
	description.text = data.description

func _on_about_to_popup() -> void:
	if data is WeaponData:
		sockets_container.generate_socket_tree(data.socket_layers)

func _on_popup_hide() -> void:
	if data is WeaponData:
		sockets_container.clear_socket_tree()
		
func _clear_details_container():
	for child in item_details_container.get_children():
		item_details_container.remove_child(child)
