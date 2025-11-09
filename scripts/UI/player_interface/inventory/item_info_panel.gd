extends PopupPanel

@onready var effect_sceen = preload("res://scenes/UI/select_card/effect.tscn")

@onready var effects_container = $Control/TextureRect/MarginContainer/EffectsContainer

var data: ItemData = null

func set_data() -> void:
	var stats := data.stats.get_modified_stats()
	for stat in stats:
		var new_effect = effect_sceen.instantiate()
		new_effect.set_effect_text(stat, stats[stat])
		effects_container.add_child(new_effect)
		
