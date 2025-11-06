class_name AroundRedBall
extends SpecialAttack

var red_ball_sceen = load("res://scenes/effects/red_ball.tscn")

@export var projectile_count: int = 4

func execute(user: Enemy, _target: Player) -> void:
	var angle_step = TAU / projectile_count
	for i in projectile_count:
		var angle = i * angle_step
		var direction = Vector2.RIGHT.rotated(angle)
		var red_ball = red_ball_sceen.instantiate()
		red_ball.global_position = user.global_position
		red_ball.velocity = direction * red_ball.speed
		user.get_tree().current_scene.add_child(red_ball)
		red_ball.set_damage(damage)
