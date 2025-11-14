extends EffectBase

@onready var animation = $AnimationPlayer
@onready var hibox = $HitBox

func _ready() -> void:
	animation.play("explosion")
	hibox.set_damage(weapon_stats.calculate_damage() + player_stats.calculate_physical_damage())


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explosion":
		execute_connected_socket()
		queue_free()
