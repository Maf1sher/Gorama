class_name CharacterSheet
extends Control

signal item_changed(slot, item)

@onready var leftRing = $TextureRect/LeftRing
@onready var rightRing = $TextureRect/RightRing
@onready var leftHand = $TextureRect/LeftHand
@onready var rightHand = $TextureRect/RightHand
@onready var head = $TextureRect/HBoxContainer/Head
@onready var chest = $TextureRect/HBoxContainer/Chest
@onready var boots = $TextureRect/HBoxContainer/Boots

func _enter_tree() -> void:
	ItemDragManager.register_fast_move_target("character_sheet", self)

func _exit_tree() -> void:
	ItemDragManager.unregister_fast_move_target("character_sheet")

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
	
func can_fast_move(item: Node) -> bool:
	match item.data.type:
		ItemTypes.Type.WEAPON:
			if leftHand.is_empty():
				return true
			elif rightHand.is_empty():
				return true
			else:
				return false
		ItemTypes.Type.HEAD:
			if head.is_empty():
				return true
			return false
		ItemTypes.Type.CHEST:
			if chest.is_empty():
				return true
			return false
		ItemTypes.Type.BOOTS:
			if boots.is_empty():
				return true
			return false
		ItemTypes.Type.RING:
			if leftRing.is_empty():
				return true
			elif rightRing.is_empty():
				return true
			return false
	return false
	
func fast_move(item: Node) -> bool:
	match item.data.type:
		ItemTypes.Type.WEAPON:
			if leftHand.is_empty():
				leftHand.place_item(item)
				return true
			elif rightHand.is_empty():
				rightHand.place_item(item)
				return true
			else:
				return false
		ItemTypes.Type.HEAD:
			if head.is_empty():
				head.place_item(item)
				return true
			return false
		ItemTypes.Type.CHEST:
			if chest.is_empty():
				chest.place_item(item)
				return true
			return false
		ItemTypes.Type.BOOTS:
			if boots.is_empty():
				boots.place_item(item)
				return true
			return false
		ItemTypes.Type.RING:
			if leftRing.is_empty():
				leftRing.place_item(item)
				return true
			elif rightRing.is_empty():
				rightRing.place_item(item)
				return true
			return false
	return false
