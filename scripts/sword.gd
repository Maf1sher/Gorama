extends Node2D

signal attack_ready

@onready var animation = $AnimationPlayer
	
func play_attack_animation():
	animation.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		animation.play("sword_return")
	elif anim_name == "sword_return":
		animation.play("RESET")
		attack_ready.emit()
