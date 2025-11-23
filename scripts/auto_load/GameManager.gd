extends Node

var player_interface: PlayerInterface = null
var wave_number: int = 0

func set_player_interface(player_interface: PlayerInterface) -> void:
	self.player_interface = player_interface
	
func increment_wave_number():
	wave_number += 1
	
func reset_wave_number():
	wave_number = 0
