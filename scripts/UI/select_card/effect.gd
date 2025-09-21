extends Label

func set_effect_text(effect: String, value: int) -> void:
	text = str(effect, " ", "+" if value>0 else "",value)
	if value > 0:
		set("theme_override_colors/font_color", Color.GREEN)
	else:
		set("theme_override_colors/font_color", Color.RED)
