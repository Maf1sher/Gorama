class_name GearStats
extends Stats

const GEAR_STAT_NAMES := [
	"physical_damage",
	"magic_damage",
	"physical_damage_percent",
	"magic_damage_percent"
]

@export var physical_damage: int = 0: 
	set(value):
		physical_damage = value
		emit_signal("stats_changed", "physical_damage", physical_damage)
@export var magic_damage: int = 0:
	set(value):
		magic_damage = value
		emit_signal("stats_changed", "magic_damage", magic_damage)
@export var physical_damage_percent: int = 0:
	set(value):
		physical_damage_percent = value
		emit_signal("stats_changed", "physical_damage_percent", physical_damage_percent)
@export var magic_damage_percent: int = 0:
	set(value):
		magic_damage_percent = value
		emit_signal("stats_changed", "magic_damage_percent", magic_damage_percent)

func get_stat_names() -> Array:
	return super.get_stat_names() + GEAR_STAT_NAMES
