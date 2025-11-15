extends EffectBase

@onready var animation = $AnimationPlayer
@onready var hitbox = $Sprite2D/HitBox

var velocity: Vector2

func _ready() -> void:
	hitbox.set_damage(weapon_stats.calculate_damage() + player_stats.calculate_physical_damage())
	rotation = direction.angle() + PI
	animation.play("shot")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shot":
		queue_free()
