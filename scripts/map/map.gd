@abstract
class_name Map
extends Node2D

signal change_map(map: String)

@export var player: Player
@export var start_point: Node2D

func get_starting_position() -> Vector2:
	return start_point.position 
