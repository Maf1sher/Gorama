extends Node2D

@onready var border = $Border

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
