class_name EntityStats
extends Stats

@export var hp: int = 100:
	set(value):
		if max_hp == 0:
			hp = value
		else:
			hp = min(value, max_hp)
		emit_signal("stats_changed", "hp", hp)

var life_steal_counter: float = 0.0

func health_depleted(damage: int) -> int:
	var taken_dmg = ceil( damage - ( tanh( armor / 70.0 ) * damage ))
	hp -= taken_dmg
	hp = max(0, hp)
	return taken_dmg

func apply_life_steal(damage: int) -> void:
	life_steal_counter += damage * (life_steal_percent/100.0)
	if life_steal_counter >= 1:
		var calculated_life_steal = int(life_steal_counter)
		hp += calculated_life_steal
		life_steal_counter -= calculated_life_steal
