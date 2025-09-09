class_name EnemyGenerator
extends Node

@onready var orc: PackedScene = preload("res://scenes/entity/Orc.tscn")

func _ready() -> void:
	for i in 1:
		await get_tree().create_timer(1).timeout
		var orc = orc.instantiate()
		orc.position = Vector2(randi_range(-100,100),randi_range(-100,100))
		get_parent().add_child(orc)
		
