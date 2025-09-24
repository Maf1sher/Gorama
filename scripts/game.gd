extends Node2D

var is_paused = false

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused

func _on_select_card_select_card_is_open(status: bool) -> void:
	toggle_pause()
