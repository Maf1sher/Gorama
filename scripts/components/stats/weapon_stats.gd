class_name WeaponStats
extends Stats

const WEAPON_STAT_NAMES := [
	"type",
	"damage",
	"damage_percent"
]

@export var type: WeaponTypes.Type
@export var damage: int = 1:
	set(value):
		if damage == value: return
		damage = value
		emit_signal("stats_changed", "damage", damage)
@export var damage_percent: int = 0:
	set(value):
		if damage_percent == value: return
		damage_percent = value
		emit_signal("stats_changed", "damage_percent", damage_percent)

func calculate_damage() -> int:
	return damage + (damage * damage_percent/100.0)

func get_stat_names() -> Array:
	return super.get_stat_names() + WEAPON_STAT_NAMES
