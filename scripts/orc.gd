extends CharacterBody2D

var player_in_area: bool = false
var attack_is_ready: bool = true
var direction := Vector2.ZERO

@export var stats: Stats

@onready var target = $"../Player"
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $HitBox

func _physics_process(delta: float) -> void:
	var enemy_to_player = (target.global_position - global_position)
	if enemy_to_player.length() > 2:
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
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false
	
	if player_in_area:
		hitbox.monitoring = false
		animated_sprite.play("attack")
	else:
		animated_sprite.play("walk")

func _on_timer_timeout() -> void:
	attack_is_ready = true

func _on_hit_box_hit_registered() -> void:
	player_in_area = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		player_in_area = false
		hitbox.monitoring = true
