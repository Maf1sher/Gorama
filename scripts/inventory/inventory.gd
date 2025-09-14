extends Control

@onready var equipment = $Equipment
@onready var character_sheet = $CharacterSheet

var is_open := false
var held_item: Node = null

func open():
	visible = true
	is_open = true
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	InputManager.unblock_input()
	
#func set_held_item(item: Node) -> void:
	#held_item = item
	
func pick_up_item(item: Node) -> void:
	held_item = item
	item.get_parent().remove_child(item)
	add_child(item)
	
func place_item(item: Node, destination: Node) -> void:
	held_item = null
	remove_child(item)
	destination.add_child(item)
		
func get_held_item() -> Node:
	return held_item
	
func get_character_sheet():
	return $CharacterSheet
