extends Node2D

@onready var border = $Border

@onready var shop_panel_sceen = preload("res://scenes/UI/shop_inventory/store_inventory.tscn")

var shop_panel: Control
var player_in_area: bool = false
var mouse_over: bool = false

func _border_visibility_update():
	border.visible = player_in_area and mouse_over

func _on_player_detector_player_detection(in_area: bool) -> void:
	player_in_area = in_area
	_border_visibility_update()

func _on_static_body_2d_mouse_entered() -> void:
	mouse_over = true
	_border_visibility_update()

func _on_static_body_2d_mouse_exited() -> void:
	mouse_over = false
	_border_visibility_update()
	
func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("action"):
		if player_in_area and mouse_over:
			var player_interface = get_tree().get_first_node_in_group("player_interface")
			player_interface.add_panel(shop_panel, PlayerInterface.PanelPosition.LEFT, 1)
			player_interface.open()
