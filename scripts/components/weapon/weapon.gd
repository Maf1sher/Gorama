class_name Weapon
extends Node2D

@export var animation: AnimationPlayer
@export var hitbox: HitBox

var stats: WeaponStats
var can_attack: bool = true

var playerStats: PlayerStats

func _ready() -> void:
	hitbox.connect("hit_registered", _on_hit_box_hit_registered)
	
func play_attack_animation():
	if can_attack:
		can_attack = false
		set_hitbox_damage()
		animation.speed_scale = \
		 (stats.attack_speed_percent + playerStats.attack_speed_percent) / 200.0
		animation.play("attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		animation.play("RESET")
		can_attack = true

func _on_hit_box_hit_registered(damage: int) -> void:
	playerStats.apply_life_steal(damage)
	
func set_hitbox_damage() -> void:
	match stats.type:
		WeaponTypes.Type.PHYSICAL:
			hitbox.set_damage(stats.calculate_damage() + playerStats.calculate_physical_damage())
		WeaponTypes.Type.MAGICAL:
			hitbox.set_damage(stats.calculate_damage() + playerStats.calculate_magic_damage())
		
