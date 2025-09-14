extends Control

signal item_changed(slot, item)

@onready var leftRing = $TextureRect/LeftRing
@onready var rightRing = $TextureRect/RightRing
@onready var leftHand = $TextureRect/LeftHand
@onready var rightHand = $TextureRect/RightHand
@onready var head = $TextureRect/HBoxContainer/Head
@onready var chest = $TextureRect/HBoxContainer/Chest
@onready var boots = $TextureRect/HBoxContainer/Boots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_left_ring() -> Node:
	return leftRing.item
	
func get_right_ring() -> Node:
	return rightRing.item
	
func get_left_hand() -> Node:
	return leftHand.item
	
func get_right_hand() -> Node:
	return rightHand.item
	
func get_head() -> Node:
	return head.item
	
func get_chest() -> Node:
	return chest.item
	
func get_boots() -> Node:
	return boots.item


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
