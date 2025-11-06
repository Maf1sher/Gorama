class_name RegenerationCounter
extends Node

@export var stats: EntityStats

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout() -> void:
	stats.hp = stats.hp + stats.hp_regeneration
