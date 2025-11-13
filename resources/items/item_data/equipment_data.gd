class_name EquipmentData
extends ItemData

const equipment_types = [
	ItemTypes.Type.WEAPON,
	ItemTypes.Type.HEAD,
	ItemTypes.Type.CHEST,
	ItemTypes.Type.BOOTS,
	ItemTypes.Type.RING,
]

@export_group("Sceen")
@export var item_sceen: PackedScene
@export var sceen_achor_point: Vector2i

@export_group("")
@export var stats: Stats

func is_equipment_type() -> bool:
	if type in equipment_types:
		return true
	return false
	
