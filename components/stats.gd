class_name Stats
extends Node

@export var physical_damage: int = 10
@export var magic_damage: int = 10
@export var physical_damage_percent: int = 0
@export var magic_damage_percent: int = 0
@export var hp: int = 100
@export var maximum_hp: int = 100
@export var hp_regeneration: int = 1
@export var attack_speed_percent: int =  100
@export var critical_hit_chance_percent: int = 0
@export var critical_damage_percent = 100
@export var armor: int = 0
@export var movement_speed: int = 100
@export var life_stealing: int = 0

func health_depleted(damage: int) -> int:
	var taken_dmg = ceil( damage - ( tanh( armor / 70.0 ) * damage ))
	hp -= taken_dmg
	hp = max(0, hp)
	return taken_dmg
