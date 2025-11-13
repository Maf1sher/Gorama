extends Effect

func execute(target: Node, sockets: Array[Socket], direction: Vector2, weapon_stats: WeaponStats, player_stats: PlayerStats) -> void:
	var cloud = effect.instantiate()
	cloud.weapon = self
	cloud.global_position = target.global_position
	
	cloud.velocity = direction * cloud.speed
	
	cloud.rotation = direction.angle() + PI
	target.get_tree().current_scene.add_child(cloud)
	cloud.set_damage(weapon_stats.calculate_damage() + player_stats.calculate_physical_damage())
