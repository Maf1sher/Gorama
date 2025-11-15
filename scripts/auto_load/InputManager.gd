extends Node

var _ui_blockers: int = 0
var _attack_blockers: int = 0

func block_input() -> void:
	_ui_blockers += 1

func unblock_input() -> void:
	_ui_blockers = max(0, _ui_blockers - 1)

func is_input_blocked() -> bool:
	return _ui_blockers > 0
	
func block_attack() -> void:
	_attack_blockers += 1

func unblock_attack() -> void:
	_attack_blockers = max(0, _ui_blockers - 1)

func is_attack_blocked() -> bool:
	return _attack_blockers > 0
