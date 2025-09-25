extends Control

@export var player: Player

@onready var bar: ProgressBar = $ProgressBar
@onready var label: Label = $ProgressBar/Label

var max_hp: int = 100:
	set(value):
		max_hp = max(value, 1)
		_update_bar()
var hp: int = 100:
	set(value):
		hp = clamp(value, 0, max_hp)
		_update_bar()

var min_width: int = 100
var max_width: int = 300


func _ready():
	max_hp = player.stats.max_hp
	hp = player.stats.hp
	player.hp_changed.connect(_on_hp_changed)

func _update_bar():
	bar.max_value = max_hp
	bar.value = hp

	label.text = "%d / %d" % [hp, max_hp]

	var new_width = clamp(max_hp, min_width, max_width)
	bar.custom_minimum_size.x = new_width
	
func _on_hp_changed(hp: int, max_hp: int):
	self.hp = hp
	self.max_hp = max_hp
