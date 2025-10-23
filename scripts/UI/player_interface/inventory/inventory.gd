extends Control

signal inventory_is_open(status: bool)

@onready var equipment = $Equipment
@onready var character_sheet = $CharacterSheet

var is_open := false
var held_item: Node = null

func open():
	visible = true
	is_open = true
	emit_signal("inventory_is_open", is_open)
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	emit_signal("inventory_is_open", is_open)
	InputManager.unblock_input()
	
func get_character_sheet():
	return $CharacterSheet
