extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var item_name = area.pick_up_item()
