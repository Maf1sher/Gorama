class_name GearData
extends EquipmentData
	
func _validate_property(property: Dictionary) -> void:
	if property.name == "type":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = "HEAD,CHEST,BOOTS,RING"
