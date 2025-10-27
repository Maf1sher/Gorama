class_name HurtBox
extends Area2D

signal received_damage(damage: int)

@export var stats: EntityStats

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null:
		var taken_damage = stats.health_depleted(hitbox.damage)
		received_damage.emit(taken_damage)
		hitbox.hit_registered.emit(taken_damage)
