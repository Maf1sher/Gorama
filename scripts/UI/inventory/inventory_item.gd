extends Sprite2D

var data: ItemData = null
var is_picked: bool = false
var size: Vector2:
	get():
		return Vector2(data.dimentions.x, data.dimentions.y) * 16
		
var anchor_point: Vector2:
	get():
		return global_position - size / 2
		
func _ready() -> void:
	if data:
		texture = data.texture

func _process(delta: float) -> void:
	if is_picked:
		global_position = get_global_mouse_position()

func set_init_position(pos: Vector2) -> void:
	global_position = pos + size / 2
	anchor_point = global_position - size / 2

func get_picked_up() -> void:
	add_to_group("held_item")
	is_picked = true
	z_index = 10
	anchor_point = global_position - size / 2
	
func get_placed(pos: Vector2i) -> void:
	is_picked = false
	global_position = pos + Vector2i(size / 2)
	z_index = 0
	anchor_point = global_position - size / 2
	remove_from_group("held_item")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_right_click"):
		if is_picked:
			do_rotation()
	
func do_rotation() -> void: 
	data.is_rotated = !data.is_rotated
	data.dimentions = Vector2i(data.dimentions.y, data.dimentions.x)
	rotation_degrees = 90 if data.is_rotated else 0
	anchor_point = global_position - size / 2
