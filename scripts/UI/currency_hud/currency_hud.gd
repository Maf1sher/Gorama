extends Control

@onready var label = $FlowContainer/Label

func _ready():
	CurrencyManager.connect("currency_changed", Callable(self, "_on_currency_changed"))
	_update_display(CurrencyManager.currencie)

func _on_currency_changed(value: int):
	_update_display(value)

func _update_display(value: int):
	label.text = str(value)
