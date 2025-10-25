extends GridContainer

const SLOT_SIZE: int = 16

@export var inventory_slot_scene: PackedScene
@export var dimentions: Vector2i

var slot_data: Array[Node] = []
var percentage_of_sales: int = 30:
	set(value):
		percentage_of_sales = clamp(value, 0, 100)

func _ready() -> void:
	create_slots()
	init_slot_data()
	
func _gui_input(event: InputEvent) -> void:	
	if event.is_action_pressed("inventory_left_click"):
		var held_item = ItemDragManager.get_held_item()
		if !held_item:
			var slot_index = get_slot_index_from_coords(get_global_mouse_position())
			var item = slot_data[slot_index]
			if !item:
				return
			else:
				if CurrencyManager.spend(item.data.price):
					item.set_price_visibility(false)
					pick_up_item(item)
					remove_item_from_slot_data(item)
		else:
			held_item.set_price_visibility(true)
			CurrencyManager.add(held_item.data.price * (percentage_of_sales/100.0))
			fast_move_place_item(held_item)

func pick_up_item(item: Node) -> void:
	ItemDragManager.pick_up_item(item)
	item.get_picked_up()

func add_item_to_slot_data(index: int, item: Node) -> void:
	for y in item.data.dimentions.y:
		for x in item.data.dimentions.x:
			slot_data[index + x + y * columns] = item

func remove_item_from_slot_data(item: Node) -> void:
	for i in slot_data.size():
		if slot_data[i] == item:
			slot_data[i] = null

func create_slots() -> void:
	self.columns = dimentions.x
	for y in dimentions.y:
		for x in dimentions.x:
			var inventory_slot = inventory_slot_scene.instantiate()
			add_child(inventory_slot)

func init_slot_data() -> void:
	slot_data.resize(dimentions.x * dimentions.y)
	slot_data.fill(null)
	
func get_slot_index_from_coords(coords: Vector2i) -> int:
	coords -= Vector2i(self.global_position)
	coords = coords / SLOT_SIZE
	var index = coords.x + coords.y * columns
	if index > dimentions.x * dimentions.y || index < 0:
		return -1
	return index
	
func get_coords_from_slot_index(index: int) -> Vector2i:
	var row = index / columns
	var column = index % columns
	return Vector2i(global_position) + Vector2i(column * SLOT_SIZE, row * SLOT_SIZE)

func fast_move_place_item(item: Node) -> bool:
	var slot_index:= find_first_matching_field(item)
	if slot_index == -1:
		return false
	
	ItemDragManager.place_item(item, self)
	item.get_placed(get_coords_from_slot_index(slot_index))
	add_item_to_slot_data(slot_index, item)
	return true

func attempt_to_add_item_data(item: Node) -> bool:
	var slot_index:= find_first_matching_field(item)
	if slot_index == -1:
		return false
		
	for y in item.data.dimentions.y:
		for x in item.data.dimentions.x:
			slot_data[slot_index + x + y * columns] = item
	item.set_init_position(get_coords_from_slot_index(slot_index))
	return true
	
func find_first_matching_field(item: Node) -> int:
	var slot_index: int = 0
	while slot_index < slot_data.size():
		if item_fits(slot_index, item.data.dimentions):
			return slot_index
		slot_index += 1
	return -1
	
func item_fits(index: int, dimentions: Vector2i) -> bool:
	for y in dimentions.y:
		for x in dimentions.x:
			var curr_index = index + x + y * columns
			if curr_index >= slot_data.size():
				return false
			if slot_data[curr_index] != null:
				return false
			var split = index / columns != (index + x) / columns
			if split:
				return false
	return true
