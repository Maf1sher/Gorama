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
    ItemDragManager.pick_up_item(item)
    held_item = ItemDragManager.get_held_item()

func place_item(item: Node, destination: Node) -> void:
    ItemDragManager.place_item(item, destination)
    held_item = ItemDragManager.get_held_item()

func swap_items(item: Node, destination: Node) -> void:
    ItemDragManager.swap_items(item, destination)
    held_item = ItemDragManager.get_held_item()

func fast_move(destination: String) -> bool:
    return ItemDragManager.fast_move(destination)


func get_held_item() -> Node:
    return ItemDragManager.get_held_item()
    
func get_character_sheet():
    return $CharacterSheet
