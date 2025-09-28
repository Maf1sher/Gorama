extends Node2D

#signal attack_ready

@onready var cloud_sceen = preload("res://scenes/effects/cloud.tscn")

@onready var animation = $AnimationPlayer
@onready var hitbox = $Sprite2D/HitBox

var attack_speed: int = 50
var can_attack: bool = true
var damage: int = 10

var playerStats: Stats
	
func play_attack_animation(stats: Stats):
	self.playerStats = stats
	if can_attack:
		can_attack = false
		self.attack_speed = stats.attack_speed_percent
		hitbox.set_damage(self.damage + stats.calculate_physical_damage())
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
	cloud.weapon = self
	cloud.global_position = global_position

	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	cloud.velocity = direction * cloud.speed
	
	cloud.rotation = direction.angle() + PI
	get_tree().current_scene.add_child(cloud)
	cloud.set_damage(damage + playerStats.calculate_physical_damage())

func _on_hit_box_hit_registered(damage: int) -> void:
	playerStats.apply_life_steal(damage)
