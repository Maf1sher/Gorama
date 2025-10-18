extends Map

var next_map_path:  = "res://scenes/maps/arena.tscn"

func _on_portal_player_entered_portal() -> void:
	change_map.emit(next_map_path)
