class_name ItemData extends Resource


@export var name: String
@export var texture: Texture2D
@export var dimentions: Vector2i
@export var item_sceen: PackedScene
@export var sceen_achor_point: Vector2i
@export var type: ItemTypes.Type

var is_rotated: bool = false
