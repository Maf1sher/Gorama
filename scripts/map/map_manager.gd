extends Node2D

@export var player: Player

@onready var save_zone_sceen: PackedScene = load("res://scenes/maps/SaveZone.tscn")

var current_map: Map

func _ready() -> void:
	if save_zone_sceen:
		current_map = save_zone_sceen.instantiate()
		current_map.connect("change_map", change_map)
		add_child(current_map)
	
func change_map(map_path: String) -> void:
	if current_map and is_instance_valid(current_map):
		current_map.queue_free()
		
	var map_scene: PackedScene = load(map_path)
	if map_scene:
		current_map = map_scene.instantiate()
		current_map.connect("change_map", change_map)
		current_map.player = player
		call_deferred("_setup_new_map")

func _setup_new_map() -> void:
	if not current_map or not is_instance_valid(current_map):
		return
		
	add_child(current_map)
	if player:
		player.position = current_map.get_starting_position()
