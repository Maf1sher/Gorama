extends Node2D

signal attack_ready

@onready var animation = $AnimationPlayer

var attack_speed = 100
	
func play_attack_animation(attack_speed: int):
	self.attack_speed = attack_speed
	animation.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		animation.speed_scale = attack_speed / 100.0
		print(animation.speed_scale)
		animation.play("sword_return")
	elif anim_name == "sword_return":
		animation.play("RESET")
		attack_ready.emit()
