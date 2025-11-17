class_name ItemTypes

enum Type {
	WEAPON,
	HEAD,
	CHEST,
	BOOTS,
	ACCESSORY,
	UPGRADE,
	OTHER
}

const equipment_types = [
	Type.WEAPON,
	Type.HEAD,
	Type.CHEST,
	Type.BOOTS,
	Type.ACCESSORY,
]

const gear_types = [
	Type.HEAD,
	Type.CHEST,
	Type.BOOTS,
	Type.ACCESSORY,
]

func is_equipment_type(type: ItemTypes.Type) -> bool:
	if type in equipment_types:
		return true
	return false
	
func is_gear_type(type: ItemTypes.Type) -> bool:
	if type in gear_types:
		return true
	return false
