extends Label

func set_effect_text(effect: String, value: int) -> void:
	text = str(format_stat_string(effect), " ", "+" if value>0 else "",value)
	if value > 0:
		set("theme_override_colors/font_color", Color.GREEN)
	else:
		set("theme_override_colors/font_color", Color.RED)
		
func format_stat_string(text: String) -> String:
	var new_text := text.replace("_", " ")
	var words = new_text.split(" ")
	
	var has_percent := false
	for i in range(words.size()):
		if words[i] == "percent":
			has_percent = true
			words.remove_at(i)
			continue
		words[i] = words[i].capitalize()
	
	new_text = " ".join(words)
	
	if has_percent:
		new_text = "% " + new_text
	
	return new_text
