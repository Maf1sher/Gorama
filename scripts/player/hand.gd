extends Node2D

const OFFSET: int = 4

func change_offset() -> void:
	if z_index == 0:
		position.x -= OFFSET
	else:
		position.x = 0
