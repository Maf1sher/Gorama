class_name RedBall
extends SpecialAttack

var red_ball_sceen = load("res://scenes/effects/red_ball.tscn")

func execute(user: Enemy, target: Player) -> void:
	var red_ball = red_ball_sceen.instantiate()
	red_ball.global_position = user.global_position
	var direction = (target.global_position - user.global_position).normalized()
	red_ball.velocity = direction * red_ball.speed
	user.get_tree().current_scene.add_child(red_ball)
	red_ball.set_damage(damage)
