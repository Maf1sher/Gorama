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
	
func pick_up_item(item: Node) -> void:
	held_item = item
	item.get_parent().remove_child(item)
	add_child(item)
	
func place_item(item: Node, destination: Node) -> void:
	held_item = null
	remove_child(item)
	destination.add_child(item)
	
func swap_items(item: Node, destination: Node) -> void:
	var tmp = held_item
	held_item = item
	item.get_parent().remove_child(item)
	add_child(item)
	remove_child(tmp)
	destination.add_child(tmp)
		
func get_held_item() -> Node:
	return held_item
	
func get_character_sheet():
	return $CharacterSheet
