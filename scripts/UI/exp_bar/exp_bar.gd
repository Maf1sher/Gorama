extends Control

signal lvl_up()

@onready var progresBar = $ProgressBar
@onready var lvl_label = $ProgressBar/Label

var exp: int = 0
var lvl: int = 1

func _ready() -> void:
	set_lvl_label()
	await reset_exp_bar()

func add_exp(amount: int) -> void:
	exp += amount
	await set_progerssbar_value(exp - cal_exp_from_lvl(lvl))
	var cal_lvl = cal_lvl_from_exp(exp)
	if lvl != cal_lvl:
		lvl += 1
		set_lvl_label()
		emit_signal("lvl_up")
		await reset_exp_bar()
		
func cal_lvl_from_exp(exp: int) -> int:
	return floor(sqrt(exp / 20.0)) + 1
	
func cal_exp_from_lvl(lvl: int) -> int:
	return ceil((lvl - 1) ** 2) * 20
	
func set_lvl_label() -> void:
	lvl_label.text = str("LvL", lvl)
	
func needed_exp_to_next_lvl(current_lvl: int, next_level: int) -> int:
	return cal_exp_from_lvl(next_level) - cal_exp_from_lvl(current_lvl)

func reset_exp_bar() -> void:
	progresBar.max_value = needed_exp_to_next_lvl(lvl, lvl +1)
	progresBar.value = 0
	await set_progerssbar_value(exp - cal_exp_from_lvl(lvl))
	
func set_progerssbar_value(value: int) -> void:
	var tween = create_tween()
	tween.tween_property(progresBar, "value", value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
