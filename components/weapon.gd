class_name Weapon
extends Node2D

@export var animation: AnimationPlayer
@export var hitbox: HitBox

var can_attack: bool = true
var damage: int = 10

var playerStats: Stats
	
func play_attack_animation():
	if can_attack:
		can_attack = false
		hitbox.set_damage(self.damage + playerStats.calculate_physical_damage())
		animation.speed_scale = playerStats.attack_speed_percent / 100.0
		animation.play("attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		animation.play("RESET")
		can_attack = true

func _on_hit_box_hit_registered(damage: int) -> void:
	playerStats.apply_life_steal(damage)
		
