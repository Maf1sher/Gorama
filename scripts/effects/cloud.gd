extends Node2D

@export var speed: float = 400.0
var velocity: Vector2

func _physics_process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		position += velocity * delta


func _on_hit_box_hit_registered() -> void:
	queue_free()
