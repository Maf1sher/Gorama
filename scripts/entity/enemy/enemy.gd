class_name Enemy
extends CharacterBody2D

signal died(name: String, exp_reward: int)

@onready var crystal_screen: PackedScene = preload("res://scenes/liftable_item/crystal.tscn")

@export_group("Componets")
@export var animated_sprite: AnimationPlayer
@export var sprite: Sprite2D
@export var hitbox: HitBox
@export var hurtbox: HurtBox
@export var health_bar: HealthBar
@export var collision_shape: CollisionShape2D
@export var player_detector: PlayerDetector
@export var hit_popup_spawner: HitPopupSpawner

@export_group("Stats")
@export var stats: EnemyStats

@export_group("Info")
@export var enemy_name: String

@export_group("Drops")
@export var exp: int = 10
@export var crystal: int = 1

@export_group("Special Attacks")
@export var min_attack_interval: float = 3.0
@export var max_attack_interval: float = 6.0
@export var special_attacks: Array[SpecialAttack] = []

@onready var regeneration_counter: RegenerationCounter

var attack_timer := 0.0

var target: Player

var player_in_area: bool = false
var attack_is_ready: bool = true
var direction := Vector2.ZERO
var can_move = true
var is_hurt = false

func _ready() -> void:
	stats = stats.duplicate()
	regeneration_counter = RegenerationCounter.new()
	add_child(regeneration_counter)
	regeneration_counter.stats = stats
	hurtbox.stats = stats
	health_bar.max_value = stats.max_hp
	health_bar.set_hp(stats.hp)
	if not animated_sprite.animation_finished.is_connected(_on_animation_player_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_player_animation_finished)
	if not hurtbox.received_damage.is_connected(_on_hurt_box_received_damage):
		hurtbox.received_damage.connect(_on_hurt_box_received_damage)
	if not player_detector.player_detection.is_connected(_on_player_detector_player_detection):
		player_detector.player_detection.connect(_on_player_detector_player_detection)
	if not hitbox.hit_registered.is_connected(_on_hit_box_hit_registered):
		hitbox.hit_registered.connect(_on_hit_box_hit_registered)
	if not stats.stats_changed.is_connected(_on_stats_stats_changed):
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
	
	attack_timer -= delta
	if attack_timer <= 0:
		_try_special_attack()
		_reset_attack_timer()

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
	hurtbox.monitoring = false
	set_physics_process(false)
	emit_signal("died", enemy_name, exp)
	animated_sprite.play("death")

func hurt():
	set_stunned(true)
	animated_sprite.play("hurt")
	
func set_stunned(value: bool):
	can_move = !value
	collision_shape.set_deferred("disabled", value)
	
func _try_special_attack():
	if special_attacks.is_empty():
		return

	var attack: SpecialAttack = special_attacks.pick_random()
	if randf() < attack.chance:
		attack.execute(self, target)

func _reset_attack_timer():
	attack_timer = randf_range(min_attack_interval, max_attack_interval)

func _on_hurt_box_received_damage(damage: int) -> void:
	hit_popup_spawner.spawn_hit_popup(damage)
	is_hurt = true

func _on_player_detector_player_detection(in_area: bool) -> void:
	player_in_area = in_area
	
func _on_hit_box_hit_registered(damage: int) -> void:
	hitbox.set_deferred("disabled", false)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"death":
			var new_crystal_screen = crystal_screen.instantiate()
			new_crystal_screen.global_position = global_position
			get_parent().add_child(new_crystal_screen)
			queue_free()
		"hurt":
			is_hurt = false
			set_stunned(false)

func _on_stats_stats_changed(stat_name: String, value: int) -> void:
	if stat_name == "hp":
		health_bar.set_hp(value)
