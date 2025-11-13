@abstract
class_name Effect
extends Resource

@export var effect: PackedScene

@abstract
func execute(target: Node, sockets: Array[Socket], direction: Vector2, weapon_stats: WeaponStats, player_stats: PlayerStats) -> void
