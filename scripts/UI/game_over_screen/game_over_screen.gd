class_name GameOverScreen
extends Control

signal animation_finished()

@export var player: Player

@onready var animation = $AnimationPlayer

func _ready() -> void:
	player.connect("died", _player_die)

func _player_die() -> void:
	visible = true
	animation.play("label")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "label":
		emit_signal("animation_finished")
