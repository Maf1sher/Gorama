class_name EnemyStats
extends Stats

@export var damage: int = 10: 
	set(value):
		damage = value
		emit_signal("stats_changed", "damage", damage)
@export var damage_percent: int = 0:
	set(value):
		damage_percent = value
		emit_signal("stats_changed", "damage_percent", damage_percent)
		
func calculate_magic_damage() -> int:
	var roll = randi() % 100
	
	return (damage + (damage * damage_percent/100.0)) \
	  * (crit_damage_percent/100.0 if roll < crit_chance_percent else 1)
