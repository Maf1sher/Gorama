extends Control

@onready var statsContainer = $TextureRect/MarginContainer/StatsContainer

var is_open: bool = false

func open():
	visible = true
	is_open = true
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	InputManager.unblock_input()
	
func set_open_status(status: bool) -> void:
	if status:
		open()
	else:
		close()

func _on_select_card_select_card_is_open(status: bool) -> void:
	set_open_status(status)

func _on_inventory_inventory_is_open(status: bool) -> void:
	set_open_status(status)

func _on_player_stats_changed(stats: Stats) -> void:
	if statsContainer:
		statsContainer.change_stats(stats)
