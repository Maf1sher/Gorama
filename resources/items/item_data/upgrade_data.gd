class_name UpgradeData
extends ItemData

@export var description: String
@export var on_hit: bool = false
@export var effect_scene: PackedScene

func _init() -> void:
	type = ItemTypes.Type.UPGRADE
	
func execute_effect(source: Node, direction: Vector2, weapon_stats, player_stats, children_sockets: Array) -> void:
	if not effect_scene:
		return
	
	var effect_instance = effect_scene.instantiate()
	effect_instance.setup(source, direction, weapon_stats, player_stats, children_sockets)

	effect_instance.global_position = source.global_position
	source.get_tree().current_scene.call_deferred("add_child", effect_instance)
