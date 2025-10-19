@tool
class_name EnemySpawnDefinition
extends Resource

@export var enemy_scene: PackedScene
@export var is_boss: bool = false

@export_group("Spawning Logic")
@export var group_size: int = 1
@export var group_count: int = 1
@export var cluster_radius: float = 50.0

@export_group("Timing")
@export var initial_delay: float = 0.0
@export var interval: float = 1.0
@export_range(0.0, 5.0) var interval_randomness: float = 0.2
