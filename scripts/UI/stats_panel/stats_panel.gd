class_name StatsPanel
extends Control

@export var player: Player

@onready var statsContainer = $TextureRect/MarginContainer/StatsContainer

var is_open: bool = false

func _ready() -> void:
	if not player:
		push_warning("Player is null")
		return
	statsContainer.change_stats(player.stats)
	player.stats_changed.connect(_on_stats_changed)
	


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

func _on_stats_changed(stats: Stats) -> void:
	if statsContainer:
		statsContainer.change_stats(stats)
