class_name ItemData extends Resource

@export_group("Info")
@export var name: String

@export_group("Inventory")
@export var texture: Texture2D
@export var dimentions: Vector2i

@export_group("Shop")
@export var price: int

@export_category("")
@export var type: ItemTypes.Type = ItemTypes.Type.OTHER

var is_rotated: bool = false

func _init() -> void:
	type = ItemTypes.Type.OTHER
	
const gear_types = [
	ItemTypes.Type.HEAD,
	ItemTypes.Type.CHEST,
	ItemTypes.Type.BOOTS,
	ItemTypes.Type.ACCESSORY,
]

func is_gear_type() -> bool:
	if type in gear_types:
		return true
	return false
	
const equipment_types = [
	ItemTypes.Type.WEAPON,
	ItemTypes.Type.HEAD,
	ItemTypes.Type.CHEST,
	ItemTypes.Type.BOOTS,
	ItemTypes.Type.ACCESSORY,
]

func is_equipment_type() -> bool:
	if type in equipment_types:
		return true
	return false
