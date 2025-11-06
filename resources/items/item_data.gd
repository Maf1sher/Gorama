class_name ItemData extends Resource

@export_group("Info")
@export var name: String

@export_group("Inventory")
@export var texture: Texture2D
@export var dimentions: Vector2i

@export_group("Sceen")
@export var item_sceen: PackedScene
@export var sceen_achor_point: Vector2i
@export var type: ItemTypes.Type

@export_group("Shop")
@export var price: int

@export_group("")
@export var stats: Stats

var is_rotated: bool = false
