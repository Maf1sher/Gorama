extends Area2D

@onready var collision_shape = $CollisionShape2D

func set_collision_shape_size(size: Vector2) -> void:
	collision_shape.shape.set_size(size)
