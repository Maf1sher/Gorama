extends Node

var currencie: int = 0

signal currency_changed(new_value: int)

func add(amount: int):
	currencie += amount
	emit_signal("currency_changed", currencie)

func spend(amount: int) -> bool:
	if currencie >= amount:
		currencie -= amount
		emit_signal("currency_changed", currencie)
		return true
	return false
