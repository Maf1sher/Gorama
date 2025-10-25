extends CanvasLayer

signal counting_completed

@export_range(0, 100) var time: int = 5

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func start_timer() -> void:
	visible = true
	label.text = str(time)
	timer.start()

func _on_timer_timeout() -> void:
	time -= 1
	label.text = str(time)
	if time <= 0:
		timer.stop()
		emit_signal("counting_completed")
