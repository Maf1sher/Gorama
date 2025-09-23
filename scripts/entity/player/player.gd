class_name Player
extends CharacterBody2D

@export var stats: Stats
@export var inventory: Node
@export var exp: Node

@onready var animated_sprite = $AnimationPlayer
@onready var health_bar = $ProgressBar
@onready var grphics_left_hand = $Graphics/LeftHand
@onready var grphics_right_hand = $Graphics/RightHand
@onready var character_sheet = inventory.get_character_sheet()

var left_hand: Node
var right_hand: Node

var current_look_dir: String = "left"
var alive: bool = true

func _ready() -> void:
	character_sheet.connect("item_changed", self._on_item_changed)
	health_bar.max_value = stats.maximum_hp

func _physics_process(delta: float) -> void:
	if InputManager.is_input_blocked():
		return
	
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * stats.movement_speed
	
	if !alive:
		die()
		
	animation()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if alive:
		if InputManager.is_input_blocked():
			return

		if Input.is_action_pressed("letf_hand_attack") and left_hand:
			left_hand.play_attack_animation(stats.attack_speed_percent)
			
		if Input.is_action_pressed("right_hand_attack") and right_hand:
			right_hand.play_attack_animation(stats.attack_speed_percent)

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
	
func add_exp(amount: int) -> void:
	exp.add_exp(amount)

func _on_hurt_box_received_damage(damage: int) -> void:
	health_bar.value = stats.hp
	if stats.hp <= 0:
		alive = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		get_tree().change_scene_to_file("res://scenes/UI/Menu.tscn")
	
func _on_item_changed(slot, item: Node) -> void:
	if slot == "left_hand":
		if item:
			var weapon = item.data.item_sceen.instantiate()
			weapon.position.x = item.data.sceen_achor_point.x
			weapon.position.y = item.data.sceen_achor_point.y
			left_hand = weapon
			grphics_left_hand.add_child(weapon)
		else:
			left_hand.get_parent().remove_child(left_hand)
			left_hand.queue_free()
			left_hand = null
	elif slot == "right_hand":
		if item:
			var weapon = item.data.item_sceen.instantiate()
			weapon.position.x = item.data.sceen_achor_point.x
			weapon.position.y = item.data.sceen_achor_point.y
			weapon.z_as_relative = true
			right_hand = weapon
			grphics_right_hand.add_child(weapon)
		else:
			right_hand.get_parent().remove_child(right_hand)
			right_hand.queue_free()
			right_hand = null
