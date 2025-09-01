extends CharacterBody2D

var player_in_area: bool = false
var attack_is_ready: bool = true
var direction := Vector2.ZERO

@export var stats: Stats

@onready var target = $"../Player"
@onready var animated_sprite = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitbox = $HitBox
@onready var health_bar = $ProgressBar

func _ready() -> void:
	health_bar.max_value = stats.maximum_hp

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
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	
	if player_in_area:
		animated_sprite.play("attack")
	else:
		animated_sprite.play("walk")

func _on_hit_box_hit_registered() -> void:
	pass

func _on_hurt_box_received_damage(damage: int) -> void:
	health_bar.value = stats.hp

func _on_player_detector_player_detection(in_area: bool) -> void:
	player_in_area = in_area
