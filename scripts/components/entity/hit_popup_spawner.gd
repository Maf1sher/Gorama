class_name HitPopupSpawner
extends Node2D

@onready var hit_popup_sceen = preload("res://scenes/components/hit_popup.tscn")
var flip_dir: bool = true

func spawn_hit_popup(value: int) -> void:
	var hit_popup = hit_popup_sceen.instantiate()
	get_parent().add_child(hit_popup)
	var horizontal = Vector2.LEFT if flip_dir else Vector2.RIGHT
	flip_dir = !flip_dir
	var dir = (horizontal + Vector2.UP * 0.7).normalized()
	hit_popup.setup(value, global_position, dir)
