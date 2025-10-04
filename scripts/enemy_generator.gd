class_name EnemyGenerator
extends Node

@export var player: Player

@onready var orc: PackedScene = preload("res://scenes/entity/Orc.tscn")
@onready var golem: PackedScene = preload("res://scenes/entity/golem.tscn")

#func _ready() -> void:
	#await summon_enemy(3, orc)
	#await summon_enemy(1, golem)
	

func summon_enemy(amount: int, enemy: PackedScene) -> void:
	for i in amount:
		await get_tree().create_timer(2).timeout
		var new_enemy = enemy.instantiate()
		new_enemy.position = Vector2(randi_range(-80,400),randi_range(-80,400))
		new_enemy.target = player
		new_enemy.connect("died", Callable(player, "add_exp"))
		get_parent().add_child(new_enemy)
