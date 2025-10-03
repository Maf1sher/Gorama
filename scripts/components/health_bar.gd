extends ProgressBar

@export var stats: EnemyStats

func _ready() -> void:
	max_value = stats.max_hp
	stats.connect("stats_changed", _stats_changed)
	
func _stats_changed(stat_name: String, value: int) -> void:
	if stat_name == "hp":
		self.value = stats.hp
