extends CanvasLayer

@onready var sellect_card = $SelectCard

func _on_exp_bar_lvl_up() -> void:
	sellect_card.open()
