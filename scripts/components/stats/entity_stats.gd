class_name EntityStats
extends Stats

@export var hp: int = 100:
	set(value):
		if max_hp == 0:
			hp = value
		else:
			hp = min(value, max_hp)
		emit_signal("stats_changed", "hp", hp)

#var timer: Timer
var life_steal_counter: float = 0.0

#func _ready() -> void:
	#timer = Timer.new()
	#timer.wait_time = 1.0
	#timer.one_shot = false
	#timer.autostart = true
	#add_child(timer)
	#timer.timeout.connect(_on_timer_timeout)
	#
#func _on_timer_timeout() -> void:
	#hp = hp + hp_regeneration

func health_depleted(damage: int) -> int:
	var taken_dmg = ceil( damage - ( tanh( armor / 70.0 ) * damage ))
	hp -= taken_dmg
	hp = max(0, hp)
	#if hp == 0:
		#timer.stop()
	return taken_dmg

func apply_life_steal(damage: int) -> void:
	life_steal_counter += damage * (life_steal_percent/100.0)
	if life_steal_counter >= 1:
		var calculated_life_steal = int(life_steal_counter)
		hp += calculated_life_steal
		life_steal_counter -= calculated_life_steal
