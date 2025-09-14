extends TextureRect

@export var dimentions: Vector2i
@export var type: Types
@export var inventory_path: NodePath
var inventory: Node
	
enum Types {WEAPON}

var item: Node = null

func _ready() -> void:
	inventory = get_node(inventory_path)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_left_click"):
		var held_item = inventory.get_held_item()
		if held_item:
			if !item:
				if held_item.data.is_rotated:
					held_item.do_rotation()
				item = held_item
				inventory.place_item(held_item, self)
				held_item.get_placed(global_position + size / 2 - held_item.size / 2)
		else:
			if item:
				inventory.pick_up_item(item)
				item.get_picked_up()
				item = null
		
