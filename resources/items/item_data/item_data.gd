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
