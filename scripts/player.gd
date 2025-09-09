class_name Player
extends CharacterBody2D

@export var stats: Stats

@onready var animated_sprite = $AnimationPlayer
@onready var health_bar = $ProgressBar
@onready var weapon = $Sprite2D/Sword
@onready var inventory = $Inventory

var input
var current_look_dir = "right"
var alive = true
var can_attack = true

func _ready() -> void:
	health_bar.max_value = stats.maximum_hp

func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	velocity = input * stats.movement_speed
	
	if !alive:
		die()
		
	animation()
	move_and_slide()
	
	if(Input.is_action_pressed("attack") and can_attack):
		can_attack = false
		weapon.play_attack_animation(stats.attack_speed_percent)

func animation():
	if !alive:
		animated_sprite.play("death")
	elif current_look_dir == "right" and get_global_mouse_position().x < global_position.x:
		animated_sprite.play("look_left")
		current_look_dir = "left"
	elif current_look_dir == "left" and get_global_mouse_position().x > global_position.x:
		animated_sprite.play("look_right")
		current_look_dir = "right"

func take_hit(damage: int) -> void:
	var taken_hp = stats.take_hit(damage)
	health_bar.value = stats.hp

func die():
	velocity = Vector2.ZERO
	can_attack = false

func _on_hurt_box_received_damage(damage: int) -> void:
	health_bar.value = stats.hp
	if stats.hp <= 0:
		alive = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		get_tree().change_scene_to_file("res://scenes/UI/Menu.tscn")

func _on_sword_attack_ready() -> void:
	can_attack = true
