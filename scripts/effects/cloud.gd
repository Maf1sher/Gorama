extends Node2D

@export var speed: float = 200.0

@onready var hitbox = $HitBox

var velocity: Vector2

func _physics_process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		position += velocity * delta

func _on_hit_box_hit_registered() -> void:
	queue_free()
	
func set_damage(damage: int) -> void:
	hitbox.set_damage(damage)
