extends Node2D

#signal attack_ready

@onready var cloud_sceen = preload("res://scenes/effects/cloud.tscn")

@onready var animation = $AnimationPlayer

var attack_speed: int = 50
var can_attack: bool = true
	
func play_attack_animation(attack_speed: int):
	if can_attack:
		can_attack = false
		self.attack_speed = attack_speed
		animation.speed_scale = attack_speed / 100.0
		animation.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		animation.speed_scale = attack_speed / 100.0
		animation.play("sword_return")
	elif anim_name == "sword_return":
		animation.play("RESET")
		#attack_ready.emit()
		can_attack = true
		
func spawn_cloud():
	var cloud = cloud_sceen.instantiate()
	cloud.global_position = global_position

	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	cloud.velocity = direction * cloud.speed
	
	cloud.rotation = direction.angle() + PI
	get_tree().current_scene.add_child(cloud)
