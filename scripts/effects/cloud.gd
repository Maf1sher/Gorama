extends EffectBase

@export var speed: float = 200.0
@export var lifetime: float = 3

@onready var hitbox = $HitBox

var velocity: Vector2

func _ready() -> void:
	set_damage(weapon_stats.calculate_damage() + player_stats.calculate_physical_damage())
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func setup(source: Node2D, dir: Vector2, weapon_stats: WeaponStats, player_stats: PlayerStats, connected_sockets: Array[Socket]):
	super.setup(source, dir, weapon_stats, player_stats, connected_sockets)
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		position += velocity * delta
		rotation = direction.angle() + PI

func _on_hit_box_hit_registered(damage: int) -> void:
	execute_connected_socket()
	queue_free()
	
func set_damage(damage: int) -> void:
	hitbox.set_damage(damage)
