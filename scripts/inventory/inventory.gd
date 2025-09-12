extends Control

var is_open := false

func open():
	visible = true
	is_open = true
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	InputManager.unblock_input()
