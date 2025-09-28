extends Weapon

@onready var cloud_sceen = preload("res://scenes/effects/cloud.tscn")
		
func spawn_cloud():
	var cloud = cloud_sceen.instantiate()
	cloud.weapon = self
	cloud.global_position = global_position

	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	cloud.velocity = direction * cloud.speed
	
	cloud.rotation = direction.angle() + PI
	get_tree().current_scene.add_child(cloud)
	cloud.set_damage(damage + playerStats.calculate_physical_damage())
