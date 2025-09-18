extends CharacterBody2D

signal died(exp_reward: int)

@export var stats: Stats
@export var target: Player

@onready var crystal: PackedScene = preload("res://scenes/liftable_item/crystal.tscn")
@onready var animated_sprite = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitbox = $HitBox
@onready var health_bar = $ProgressBar
@onready var collision_shape = $CollisionShape2D

var player_in_area: bool = false
var attack_is_ready: bool = true
var direction := Vector2.ZERO
var can_move = true
var is_hurt = false

func _ready() -> void:
	health_bar.max_value = stats.maximum_hp

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
		animated_sprite.play("attack")
	else:
		animated_sprite.play("walk")

func die():
	set_physics_process(false)
	emit_signal("died", 15)
	animated_sprite.play("death")

func hurt():
	set_stunned(true)
	animated_sprite.play("hurt")
	
func set_stunned(value: bool):
	can_move = !value
	collision_shape.set_deferred("disabled", value)

func _on_hurt_box_received_damage(damage: int) -> void:
	is_hurt = true
	health_bar.value = stats.hp

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
