extends CharacterBody2D

var player_in_area = false
var direction := Vector2.ZERO
var attack_is_ready: bool = true

@export var stats: Stats

@onready var target = $"../Player"
@onready var animated_sprite = $AnimatedSprite2D

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
	attack_target()
	move_and_slide()
	
func attack_target() -> void:
	if player_in_area and attack_is_ready:
		attack_is_ready = false
		$Timer.start()


func animation() -> void:
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false
	
	if player_in_area:
		animated_sprite.play("attack")
	else:
		animated_sprite.play("walk")

func _on_timer_timeout() -> void:
	attack_is_ready = true

func _on_hit_box_body_entered(body: Node2D) -> void:
	player_in_area = true

func _on_hit_box_body_exited(body: Node2D) -> void:
	player_in_area = false
