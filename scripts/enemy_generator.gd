class_name EnemyGenerator
extends Node

@export var player: Player

@onready var orc: PackedScene = preload("res://scenes/entity/Orc.tscn")

func _ready() -> void:
	for i in 2:
		await get_tree().create_timer(1).timeout
		var orc = orc.instantiate()
		orc.position = Vector2(randi_range(-100,100),randi_range(-100,100))
		orc.target = player
		orc.connect("died", Callable(player, "add_exp"))
		get_parent().add_child(orc)
		
