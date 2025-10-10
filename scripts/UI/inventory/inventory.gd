extends Control

signal inventory_is_open(status: bool)
signal equipment_changed(slot, item)

@onready var equipment = $Equipment
@onready var character_sheet = $CharacterSheet

var is_open := false
var held_item: Node = null

# Registry of named fast-move targets (e.g., "character_sheet", "shop").
var fast_move_targets: Dictionary = {}

func _ready() -> void:
    # Forward CharacterSheet equipment changes via an inventory-level signal
    if character_sheet and character_sheet.has_signal("item_changed"):
        character_sheet.connect("item_changed", Callable(self, "_on_character_sheet_item_changed"))
    # Backwards-compatible default target
    register_fast_move_target("character_sheet", Callable(character_sheet, "fast_move"))

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
	
func fast_move(destination: String) -> bool:
    if held_item == null:
        return false
    if fast_move_targets.has(destination):
        var callable: Callable = fast_move_targets[destination]
        return callable.call(held_item)
    return false
		
		
func get_held_item() -> Node:
	return held_item
	
func get_character_sheet():
	return $CharacterSheet

func register_fast_move_target(name: StringName, handler: Callable) -> void:
    fast_move_targets[name] = handler

func unregister_fast_move_target(name: StringName) -> void:
    fast_move_targets.erase(name)

func _on_character_sheet_item_changed(slot, item) -> void:
    emit_signal("equipment_changed", slot, item)
