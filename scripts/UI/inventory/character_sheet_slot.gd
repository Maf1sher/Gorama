extends TextureRect

signal item_changed(item)

@export var dimentions: Vector2i
@export var type: ItemTypes.Type
@export var inventory_path: NodePath

@export var fill_texture: Texture2D

@onready var fill = $Fill

var inventory: Node
var equipment_grid: Node = null

var item: Node = null

func _ready() -> void:
	inventory = get_node(inventory_path)
	fill.texture = fill_texture
	# Locate equipment grid for fast-move operations
	if inventory and inventory.has_node("Equipment/ItemGrid"):
		equipment_grid = inventory.get_node("Equipment/ItemGrid")

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_left_click"):
		# Shift-click: move item from this slot to Equipment grid if it fits
		if Input.is_key_pressed(KEY_SHIFT):
			if item and equipment_grid and inventory.get_held_item() == null:
				var to_move := item
				pick_up_item()
				if !equipment_grid.fast_move_in(to_move):
					# Restore back if cannot place
					place_item(to_move)
				return
		var held_item = inventory.get_held_item()
		if held_item:
			if held_item.data.type == type:
				if !item:
					place_item(held_item)
				else:
					swap_items(held_item)
					
		else:
			if item:
				pick_up_item()

func place_item(held_item: Node) -> void:
	if held_item.data.is_rotated:
		held_item.do_rotation()
	item = held_item
	inventory.place_item(held_item, self)
	held_item.get_placed(global_position + size / 2 - held_item.size / 2)
	fill.visible = false
	emit_signal("item_changed", item)
	
func pick_up_item() -> void:
	inventory.pick_up_item(item)
	item.get_picked_up()
	item = null
	fill.visible = true
	emit_signal("item_changed", item)
	
func swap_items(held_item: Node) -> void:
	var tmp = item
	item.get_picked_up()
	item = null
	emit_signal("item_changed", item)
	inventory.swap_items(tmp, self)
	if held_item.data.is_rotated:
		held_item.do_rotation()
	item = held_item
	held_item.get_placed(global_position + size / 2 - held_item.size / 2)
	emit_signal("item_changed", item)
	
func is_empty() -> bool:
	return !item
