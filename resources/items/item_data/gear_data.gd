class_name GearData
extends EquipmentData

const gear_types = [
	ItemTypes.Type.HEAD,
	ItemTypes.Type.CHEST,
	ItemTypes.Type.BOOTS,
	ItemTypes.Type.RING,
]

func is_equipment_type() -> bool:
	if type in equipment_types:
		return true
	return false
	
func _validate_property(property: Dictionary) -> void:
	if property.name == "type":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = "HEAD,CHEST,BOOTS,RING"
