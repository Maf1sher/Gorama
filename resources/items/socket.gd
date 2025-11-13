class_name Socket
extends Resource

var item: UpgradeData
var connections: Array[Socket] = []

func execute_effect(source: Node, direction: Vector2, weapon_stats: WeaponStats, player_stats: PlayerStats) -> void:
	if item:
		item.execute_effect(source, direction, weapon_stats, player_stats, connections)
	
