extends Control

signal item_changed(slot, item)

@onready var leftRing = $TextureRect/LeftRing
@onready var rightRing = $TextureRect/RightRing
@onready var leftHand = $TextureRect/LeftHand
@onready var rightHand = $TextureRect/RightHand
@onready var head = $TextureRect/HBoxContainer/Head
@onready var chest = $TextureRect/HBoxContainer/Chest
@onready var boots = $TextureRect/HBoxContainer/Boots
@onready var equipment_grid = $"../Equipment/ItemGrid"

func _on_left_ring_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "left_ring", item)


func _on_right_ring_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "right_ring", item)


func _on_left_hand_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "left_hand", item)


func _on_right_hand_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "right_hand", item)


func _on_head_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "head", item)


func _on_chest_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "chest", item)


func _on_boots_item_changed(item: Variant) -> void:
	emit_signal("item_changed", "boots", item)
	
func fast_move(item: Node) -> bool:
    match item.data.type:
        ItemTypes.Type.WEAPON:
            if leftHand.is_empty():
                leftHand.place_item(item)
                return true
            elif rightHand.is_empty():
                rightHand.place_item(item)
                return true
    # Fallback: move to Equipment grid if there is space and the item fits
    if is_instance_valid(equipment_grid):
        return equipment_grid.fast_move_in(item)
    return false

func _ready() -> void:
    # Register as a fast-move target globally
    ItemDragManager.register_fast_move_target("character_sheet", Callable(self, "fast_move"))

func _exit_tree() -> void:
    ItemDragManager.unregister_fast_move_target("character_sheet")
