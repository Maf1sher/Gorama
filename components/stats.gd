class_name Stats
extends Node

signal stats_changed(stat_name: String, value: int)

@export var physical_damage: int = 10: 
	set(value):
		physical_damage = value
		emit_signal("stats_changed", "physical_damage", physical_damage)
@export var magic_damage: int = 10:
	set(value):
		magic_damage = value
		emit_signal("stats_changed", "magic_damage", magic_damage)
@export var physical_damage_percent: int = 0:
	set(value):
		physical_damage_percent = value
		emit_signal("stats_changed", "physical_damage_percent", physical_damage_percent)
@export var magic_damage_percent: int = 0:
	set(value):
		magic_damage_percent = value
		emit_signal("stats_changed", "magic_damage_percent", magic_damage_percent)
@export var hp: int = 100:
	set(value):
		hp = min(value, max_hp)
		emit_signal("stats_changed", "hp", hp)
@export var max_hp: int = 100:
	set(value):
		max_hp = value
		emit_signal("stats_changed", "max_hp", max_hp)
@export var hp_regeneration: int = 0:
	set(value):
		hp_regeneration = value
		emit_signal("stats_changed", "hp_regeneration", hp_regeneration)
@export var attack_speed_percent: int =  100:
	set(value):
		attack_speed_percent = value
		emit_signal("stats_changed", "attack_speed_percent", attack_speed_percent)
@export var crit_chance_percent: int = 0:
	set(value):
		crit_chance_percent = min(value, 100)
		emit_signal("stats_changed", "crit_chance_percent", crit_chance_percent)
@export var crit_damage_percent: int = 100:
	set(value):
		crit_damage_percent = value
		emit_signal("stats_changed", "crit_damage_percent", crit_damage_percent)
@export var armor: int = 0:
	set(value):
		armor = value
		emit_signal("stats_changed", "armor", armor)
@export var movement_speed: int = 100:
	set(value): 
		movement_speed = value
		emit_signal("stats_changed", "movement_speed", movement_speed)
@export var life_steal_percent: int = 0:
	set(value):
		life_steal_percent = value
		emit_signal("stats_changed", "life_steal_percent", life_steal_percent)

var timer: Timer
var life_steal_counter: float = 0.0

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout() -> void:
	hp = hp + hp_regeneration
		
func calculate_physical_damage() -> int:
	var roll = randi() % 100
	
	return (physical_damage + (physical_damage * physical_damage_percent/100.0)) \
	  * (crit_damage_percent/100.0 if roll < crit_chance_percent else 1)
	
func calculate_magic_damage() -> int:
	var roll = randi() % 100
	
	return (magic_damage + (magic_damage * magic_damage_percent/100.0)) \
	  * (crit_damage_percent/100.0 if roll < crit_chance_percent else 1)

func health_depleted(damage: int) -> int:
	var taken_dmg = ceil( damage - ( tanh( armor / 70.0 ) * damage ))
	hp -= taken_dmg
	hp = max(0, hp)
	if hp == 0:
		timer.stop()
	return taken_dmg
	
func apply_life_steal(damage: int) -> void:
	life_steal_counter += damage * (life_steal_percent/100.0)
	print(life_steal_counter)
	if life_steal_counter >= 1:
		var calculated_life_steal = int(life_steal_counter)
		print(calculated_life_steal)
		hp += calculated_life_steal
		life_steal_counter -= calculated_life_steal
		
	
	
