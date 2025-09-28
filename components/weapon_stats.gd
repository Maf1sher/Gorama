class_name WeaponStats
extends Node

@export var type: WeaponTypes.Type
@export var damage: int = 1
@export var damage_percent: int = 0
@export var attack_speed_percent: int = 100

func calculate_damage() -> int:
	return damage + (damage * damage_percent/100.0)
