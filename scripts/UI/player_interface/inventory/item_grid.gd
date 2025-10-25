extends ItemGrid

func _ready() -> void:
	super()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_left_click"):
		if Input.is_key_pressed(KEY_SHIFT):
			var slot_index = _get_slot_index_from_coords(get_global_mouse_position())
			var item = slot_data[slot_index]
			if !item:
				return
			if ItemDragManager.can_fast_move(item, "character_sheet"):
				_remove_item_from_slot_data(item)
				ItemDragManager.fast_move(item, "character_sheet")
		else:
			var held_item = ItemDragManager.get_held_item()
			if !held_item:
				var slot_index = _get_slot_index_from_coords(get_global_mouse_position())
				var item = slot_data[slot_index]
				if !item:
					return
				pick_up_item(item)
				_remove_item_from_slot_data(item)
			else:
				if !detect_held_item_intersection(held_item):
					return
				var offset = Vector2(SLOT_SIZE, SLOT_SIZE) / 2
				var index = _get_slot_index_from_coords(held_item.anchor_point + offset)
				var items = items_in_area(index, held_item.data.dimentions)
				if items.size():
					if items.size() == 1:
						place_item(held_item, index)
						_remove_item_from_slot_data(items[0])
						_add_item_to_slot_data(index, held_item)
						pick_up_item(items[0])
					return
				place_item(held_item, index)
				_add_item_to_slot_data(index, held_item)

func detect_held_item_intersection(held_item: Node) -> bool:
	var h_rect = Rect2(held_item.anchor_point, held_item.size)
	var g_rect = Rect2(global_position, size)
	var inter = h_rect.intersection(g_rect).size
	return (inter.x * inter.y) / (held_item.size.x * held_item.size.y) > 0.8

func items_in_area(index: int, item_dimentions: Vector2i) -> Array:
	var items: Dictionary = {}
	for y in item_dimentions.y:
		for x in item_dimentions.x:
			var slot_index = index + x + y * columns
			var item = slot_data[slot_index]
			if !item:
				continue
			if !items.has(item):
				items[item] = true
	return items.keys() if items.size() else []
