class_name SpecialAttack
extends Resource

@export_range(0.0, 1.0) var chance: float = 0.5
@export var cooldown: float = 2.0
@export var damage: int = 10

func execute(user: Enemy, target: Player) -> void:
	pass
