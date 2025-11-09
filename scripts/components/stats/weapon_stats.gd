class_name WeaponStats
extends Stats

const WEAPON_STAT_NAMES := [
	"type",
	"damage",
	"damage_percent"
]

@export var type: WeaponTypes.Type
@export var damage: int = 1
@export var damage_percent: int = 0

func calculate_damage() -> int:
	return damage + (damage * damage_percent/100.0)

func get_stat_names() -> Array:
	return super.get_stat_names() + WEAPON_STAT_NAMES
