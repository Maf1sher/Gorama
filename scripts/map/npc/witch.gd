extends Node2D

@onready var border = $Border

@onready var upgrade_panel_sceen = preload("res://scenes/UI/upgrade_inventory/upgrade_inventory.tscn")

var upgrade_panel: Control
var player_in_area: bool = false
var mouse_over: bool = false

func _ready() -> void:
	upgrade_panel = upgrade_panel_sceen.instantiate()

func _border_visibility_update():
	border.visible = player_in_area and mouse_over

func _on_player_detector_player_detection(in_area: bool) -> void:
	player_in_area = in_area
	_change_block_attack()
	_border_visibility_update()

func _on_static_body_2d_mouse_entered() -> void:
	mouse_over = true
	_change_block_attack()
	_border_visibility_update()

func _on_static_body_2d_mouse_exited() -> void:
	mouse_over = false
	_change_block_attack()
	_border_visibility_update()
	
func _change_block_attack() -> void:
	if mouse_over and player_in_area:
		InputManager.block_attack()
	else:
		InputManager.unblock_attack()
	
func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("action"):
		if player_in_area and mouse_over:
			var player_interface = GameManager.player_interface
			player_interface.remove_panel(player_interface.get_stats_panel_node())
			player_interface.add_panel(upgrade_panel, PlayerInterface.PanelPosition.RIGHT, 1)
			player_interface.open()
