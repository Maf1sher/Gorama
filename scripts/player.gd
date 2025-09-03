class_name Player
extends CharacterBody2D

@export var stats: Stats

@onready var animated_sprite = $AnimationPlayer
@onready var health_bar = $ProgressBar
@onready var weapon = $AnimatedSprite2D/Sword

var input
var current_look_dir = "right"

func _ready() -> void:
	health_bar.max_value = stats.maximum_hp

func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	velocity = input * stats.movement_speed
		
	if input.x > 0:
		current_look_dir = "right"
	elif input.x < 0:
		current_look_dir = "left"
		
	if velocity and current_look_dir == "right":
		animated_sprite.play("walk_right")
	elif velocity and current_look_dir == "left":
		animated_sprite.play("walk_left")
	else:
		animated_sprite.play("idle")
	
	move_and_slide()
	
	if(Input.is_action_pressed("attack")):
		weapon.play_attack_animation()

func take_hit(damage: int) -> void:
	var taken_hp = stats.take_hit(damage)
	health_bar.value = stats.hp


func _on_hurt_box_received_damage(damage: int) -> void:
	health_bar.value = stats.hp
