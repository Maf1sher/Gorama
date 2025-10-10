extends CanvasLayer

signal item_picked_up(item: Node)
signal item_placed(item: Node, destination: Node)
signal item_swapped(picked_up: Node, placed: Node, destination: Node)

var held_item: Node = null
var fast_move_targets: Dictionary = {}

func pick_up_item(item: Node) -> void:
	if item == null:
		return
	held_item = item
	var current_parent: Node = item.get_parent()
	if current_parent:
		current_parent.remove_child(item)
	add_child(item)
	emit_signal("item_picked_up", item)

func place_item(item: Node, destination: Node) -> void:
	if item == null or destination == null:
		return
	held_item = null
	if item.get_parent() == self:
		remove_child(item)
	destination.add_child(item)
	emit_signal("item_placed", item, destination)

func swap_items(item: Node, destination: Node) -> void:
	if item == null or destination == null:
		return
	var item_to_place: Node = held_item
	held_item = item
	var current_parent: Node = item.get_parent()
	if current_parent:
		current_parent.remove_child(item)
	add_child(item)
	if item_to_place:
		if item_to_place.get_parent() == self:
			remove_child(item_to_place)
		destination.add_child(item_to_place)
	emit_signal("item_swapped", held_item, item_to_place, destination)

func get_held_item() -> Node:
	return held_item

func is_holding() -> bool:
	return held_item != null

func register_fast_move_target(id: String, receiver: Callable) -> void:
	fast_move_targets[id] = receiver

func unregister_fast_move_target(id: String) -> void:
	if fast_move_targets.has(id):
		fast_move_targets.erase(id)

func fast_move(destination_id: String) -> bool:
	if held_item == null:
		return false
	var receiver: Callable = fast_move_targets.get(destination_id, null)
	if receiver and receiver.is_valid():
		return receiver.call(held_item)
	return false
