extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var item_name = area.pick_up_item()
	if item_name == "crystal":
		CurrencyManager.add(1)
