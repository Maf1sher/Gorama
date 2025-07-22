class_name HurtBox
extends Area2D

signal received_damage(damage: int)

@export var stats: Stats

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null:
		var taken_damage = stats.deal_damage(hitbox.damage)
		received_damage.emit(taken_damage)
