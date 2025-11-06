class_name Player
extends CharacterBody2D

signal stats_changed(stats: PlayerStats)
signal hp_changed(hp: int, max_hp: int)
signal died

@export var exp: Node
@export var stats: PlayerStats


@onready var animated_sprite = $AnimationPlayer
@onready var hurt_box: HurtBox = $HurtBox
@onready var hit_popup_spawner: HitPopupSpawner = $HitPopupSpawner
@onready var regeneration_counter: RegenerationCounter = $RegenerationCounter

@onready var graphics_left_hand = $Graphics/LeftHand
@onready var graphics_right_hand = $Graphics/RightHand
@onready var graphics_head = $Graphics/Head
@onready var graphics_chest = $Graphics/Chest
@onready var graphics_boots = $Graphics/Boots
@onready var graphics_left_accessory = $Graphics/LeftAccessory
@onready var graphics_right_accessory = $Graphics/RightAccessory

var active_cards: Array = []

var _left_hand: Weapon
var _right_hand: Weapon
var _head: Node
var _chest: Node
var _boots: Node
var _left_accessory: Node
var _right_accessory: Node

var _left_hand_data: ItemData
var _right_hand_data: ItemData
var _head_data: ItemData
var _chest_data: ItemData
var _boots_data: ItemData
var _left_accessory_data: ItemData
var _right_accessory_data: ItemData

var current_look_dir: String = "left"
var alive: bool = true

func _ready() -> void:
	regeneration_counter.stats = stats
	hurt_box.stats = stats
	stats.stats_changed.connect(_on_stats_stats_changed)
	emit_signal("stats_changed", stats)

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

		if Input.is_action_pressed("letf_hand_attack") and _left_hand:
			_left_hand.play_attack_animation()
			
		if Input.is_action_pressed("right_hand_attack") and _right_hand:
			_right_hand.play_attack_animation()

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

func die():
	velocity = Vector2.ZERO
	emit_signal("died")
	
func add_exp(amount: int) -> void:
	if alive:
		exp.add_exp(amount)

func _on_hurt_box_received_damage(damage: int) -> void:
	hit_popup_spawner.spawn_hit_popup(damage)
	if stats.hp <= 0:
		alive = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		CurrencyManager.reset()
		get_tree().change_scene_to_file("res://scenes/UI/Menu.tscn")
	
func _on_item_changed(slot, item: Node) -> void:
	match slot:
		"left_hand":
			if item:
				var weapon = item.data.item_sceen.instantiate()
				weapon.position.x = item.data.sceen_achor_point.x
				weapon.position.y = item.data.sceen_achor_point.y
				weapon.stats = item.data.stats
				_left_hand = weapon
				_left_hand.playerStats = stats
				graphics_left_hand.add_child(weapon)
			else:
				_left_hand.get_parent().remove_child(_left_hand)
				_left_hand.queue_free()
				_left_hand = null
		"right_hand":
			if item:
				var weapon = item.data.item_sceen.instantiate()
				weapon.position.x = item.data.sceen_achor_point.x
				weapon.position.y = item.data.sceen_achor_point.y
				weapon.stats = item.data.stats
				_right_hand = weapon
				_right_hand.playerStats = stats
				graphics_right_hand.add_child(weapon)
			else:
				_right_hand.get_parent().remove_child(_right_hand)
				_right_hand.queue_free()
				_right_hand = null
		"head":
			var result = _change_item(item, _head, graphics_head, _head_data)
			_head = result.instance
			_head_data = result.data
		"chest":
			var result = _change_item(item, _chest, graphics_chest, _chest_data)
			_chest = result.instance
			_chest_data = result.data
		"boots":
			var result = _change_item(item, _boots, graphics_boots, _boots_data)
			_boots = result.instance
			_boots_data = result.data
		"left_ring":
			var result = _change_item(item, _left_accessory, graphics_left_accessory, _left_accessory_data)
			_left_accessory = result.instance
			_left_accessory_data = result.data
		"right_ring":
			var result = _change_item(item, _right_accessory, graphics_right_accessory, _right_accessory_data)
			_right_accessory = result.instance
			_right_accessory_data = result.data

func _change_item(item: Node, slot: Node, graphics: Node2D, data: ItemData) -> Dictionary:
	if item:
		var instance = item.data.item_sceen.instantiate()
		instance.position.x = item.data.sceen_achor_point.x
		instance.position.y = item.data.sceen_achor_point.y
		graphics.add_child(instance)
		data = item.data
		stats.add_gear_stats(item.data.stats)
		return {"instance": instance, "data": data}
	else:
		stats.remove_gear_stats(data.stats)
		slot.get_parent().remove_child(slot)
		slot.queue_free()
		return {"instance": null, "data": null}

func _on_stats_stats_changed(stat_name: String, value: int) -> void:
	if stat_name == "hp" or stat_name == "max_hp":
		emit_signal("hp_changed", stats.hp, stats.max_hp)
	emit_signal("stats_changed", stats)
	
func apply_card(card: CardData) -> void:
	active_cards.append(card)
	for effect in card.effects:
		if effect.target == "player":
			match effect.stat:
				"physical_damage":
					stats.physical_damage += effect.value
				"magic_damage":
					stats.magic_damage += effect.value
				"physical_damage_percent":
					stats.physical_damage_percent += effect.value
				"magic_damage_percent":
					stats.magic_damage_percent += effect.value
				"max_hp":
					stats.max_hp += effect.value
				"hp_regeneration":
					stats.hp_regeneration += effect.value
				"attack_speed_percent":
					stats.attack_speed_percent += effect.value
				"crit_chance_percent":
					stats.crit_chance_percent += effect.value
				"crit_damage_percent":
					stats.crit_damage_percent += effect.value
				"armor":
					stats.armor += effect.value
				"movement_speed":
					stats.movement_speed += effect.value
				"life_steal_percent":
					stats.life_steal_percent += effect.value
