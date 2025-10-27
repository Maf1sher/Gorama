class_name GearStats
extends Stats

@export var physical_damage: int = 10: 
	set(value):
		physical_damage = value
		emit_signal("stats_changed", "physical_damage", physical_damage)
@export var magic_damage: int = 10:
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
