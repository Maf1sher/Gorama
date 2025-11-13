class_name EffectBase
extends Node2D

var source: Node2D
var direction: Vector2
var weapon_stats: WeaponStats
var player_stats: PlayerStats
var connected_sockets: Array[Socket] = []

func setup(source: Node2D, dir: Vector2, weapon_stats: WeaponStats, player_stats: PlayerStats, connected_sockets: Array[Socket]):
	self.source = source
	self.direction = dir.normalized()
	self.weapon_stats = weapon_stats
	self.player_stats = player_stats
	self.connected_sockets = connected_sockets
	
func execute_connected_socket() -> void:
	for socket in connected_sockets:
		socket.execute_effect(self, direction, weapon_stats, player_stats)
