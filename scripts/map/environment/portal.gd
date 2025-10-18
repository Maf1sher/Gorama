extends Node2D

signal player_entered_portal()

func _on_player_detector_player_detection(in_area: bool) -> void:
	if in_area == true:
		player_entered_portal.emit()
