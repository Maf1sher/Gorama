class_name Stats
extends Resource

signal stats_changed(stat_name: String, value: int)

const STAT_NAMES := [
	"max_hp",
	"hp_regeneration",
	"attack_speed_percent",
	"crit_chance_percent",
	"crit_damage_percent",
	"armor",
	"movement_speed",
	"life_steal_percent"
]

@export var max_hp: int = 0:
	set(value):
		max_hp = value
		emit_signal("stats_changed", "max_hp", max_hp)
@export var hp_regeneration: int = 0:
	set(value):
		hp_regeneration = value
		emit_signal("stats_changed", "hp_regeneration", hp_regeneration)
@export var attack_speed_percent: int =  0:
	set(value):
		attack_speed_percent = value
		emit_signal("stats_changed", "attack_speed_percent", attack_speed_percent)
@export var crit_chance_percent: int = 0:
	set(value):
		crit_chance_percent = min(value, 100)
		emit_signal("stats_changed", "crit_chance_percent", crit_chance_percent)
@export var crit_damage_percent: int = 0:
	set(value):
		crit_damage_percent = value
		emit_signal("stats_changed", "crit_damage_percent", crit_damage_percent)
@export var armor: int = 0:
	set(value):
		armor = value
		emit_signal("stats_changed", "armor", armor)
@export var movement_speed: int = 0:
	set(value): 
		movement_speed = value
		emit_signal("stats_changed", "movement_speed", movement_speed)
@export var life_steal_percent: int = 0:
	set(value):
		life_steal_percent = value
		emit_signal("stats_changed", "life_steal_percent", life_steal_percent)

func get_stat_names() -> Array:
	return STAT_NAMES

func add_stats(stats: Stats) -> void:
	for stat in STAT_NAMES:
		set(stat, get(stat) + stats.get(stat))
	
func remove_stats(stats: Stats) -> void:
	for stat in STAT_NAMES:
		set(stat, get(stat) - stats.get(stat))
	
func get_modified_stats() -> Dictionary:
	var result := {}
	for stat in get_stat_names():
		var value = get(stat)
		if value != 0:
			result[stat] = value
	return result
