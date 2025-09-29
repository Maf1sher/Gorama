class_name HitPopup
extends Label

@export var float_speed: float = 50.0
@export var lifetime: float = 1.0

var _time_passed: float = 0.0
var _direction: Vector2 = Vector2.ZERO

func setup(value: int, position: Vector2, direction: Vector2) -> void:
	text = str(value)
	global_position = position
	_direction = direction.normalized()

func _process(delta: float) -> void:
	position += _direction * float_speed * delta
	modulate.a = lerp(1.0, 0.0, _time_passed / lifetime)
	_time_passed += delta
	if _time_passed >= lifetime:
		queue_free()
