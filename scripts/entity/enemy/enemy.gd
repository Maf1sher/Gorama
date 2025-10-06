class_name Enemy
extends CharacterBody2D

signal died(exp_reward: int)

@onready var crystal: PackedScene = preload("res://scenes/liftable_item/crystal.tscn")

@export var stats: EnemyStats
@export var animated_sprite: AnimationPlayer
@export var sprite: Sprite2D
@export var hitbox: HitBox
@export var hurtbox: HurtBox
@export var health_bar: HealthBar
@export var collision_shape: CollisionShape2D
@export var player_detector: PlayerDetector
@export var hit_popup_spawner: HitPopupSpawner

@export var exp: int = 10

var target: Player

var player_in_area: bool = false
var attack_is_ready: bool = true
var direction := Vector2.ZERO
var can_move = true
var is_hurt = false

func _ready() -> void:
	health_bar.max_value = stats.max_hp
	health_bar.set_hp(stats.hp)
	animated_sprite.animation_finished.connect(_on_animation_player_animation_finished)
	hurtbox.received_damage.connect(_on_hurt_box_received_damage)
	player_detector.player_detection.connect(_on_player_detector_player_detection)
	hitbox.hit_registered.connect(_on_hit_box_hit_registered)
	stats.stats_changed.connect(_on_stats_stats_changed)

func _physics_process(delta: float) -> void:
	var enemy_to_player = (target.global_position - global_position)
	if enemy_to_player.length() > 2 and can_move:
		direction = enemy_to_player.normalized()
	else:
		direction = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		velocity = direction * stats.movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, stats.movement_speed)
		velocity.y = move_toward(velocity.y, 0, stats.movement_speed)
	
	animation()
	move_and_slide()

func animation() -> void:
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		
	if stats.hp <= 0:
		die()
	elif is_hurt:
		hurt()
	elif player_in_area:
		hitbox.damage = stats.calculate_damage()
		animated_sprite.play("attack")
	else:
		animated_sprite.play("walk")

func die():
	set_physics_process(false)
	emit_signal("died", exp)
	animated_sprite.play("death")

func hurt():
	set_stunned(true)
	animated_sprite.play("hurt")
	
func set_stunned(value: bool):
	can_move = !value
	collision_shape.set_deferred("disabled", value)

func _on_hurt_box_received_damage(damage: int) -> void:
	hit_popup_spawner.spawn_hit_popup(damage, global_position)
	is_hurt = true

func _on_player_detector_player_detection(in_area: bool) -> void:
	player_in_area = in_area
	
func _on_hit_box_hit_registered() -> void:
	hitbox.set_deferred("disabled", false)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"death":
			var new_crystal = crystal.instantiate()
			new_crystal.global_position = global_position
			get_parent().add_child(new_crystal)
			queue_free()
		"hurt":
			is_hurt = false
			set_stunned(false)

func _on_stats_stats_changed(stat_name: String, value: int) -> void:
	if stat_name == "hp":
		health_bar.set_hp(value)
