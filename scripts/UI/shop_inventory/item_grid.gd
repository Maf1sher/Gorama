extends ItemGrid

var percentage_of_sales: int = 30:
	set(value):
		percentage_of_sales = clamp(value, 0, 100)

func _ready() -> void:
	super()

func _gui_input(event: InputEvent) -> void:	
	if event.is_action_pressed("inventory_left_click"):
		var held_item = ItemDragManager.get_held_item()
		if !held_item:
			var slot_index = _get_slot_index_from_coords(get_global_mouse_position())
			var item = slot_data[slot_index]
			if !item:
				return
			else:
				if CurrencyManager.spend(item.data.price):
					item.set_price_visibility(false)
					pick_up_item(item)
					_remove_item_from_slot_data(item)
		else:
			held_item.set_price_visibility(true)
			CurrencyManager.add(held_item.data.price * (percentage_of_sales/100.0))
			fast_move_place_item(held_item)
