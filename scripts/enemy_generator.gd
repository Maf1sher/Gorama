class_name EnemyGenerator
extends Node2D

signal wave_finished
signal enemy_spawned(enemy_instance: Enemy)
signal enemy_died(name: String)

@export var waves: Array[WaveResource]
@export var spawn_area: Area2D

var player: Player

var _is_running: bool = false
var _is_paused: bool = false
var _current_phase_index: int = -1
var _active_spawners: Array[Dictionary] = []
var _current_wave: WaveResource

func _ready() -> void:
	start_wave()

func start_wave():
	if not waves or waves.size() == 0 or not spawn_area:
		return
	if _is_running:
		return
	
	_current_wave = waves[min(GameManager.wave_number, waves.size() - 1)]
	_is_running = true
	_is_paused = false
	_current_phase_index = -1
	_clear_active_spawners()
	_start_next_phase()

func pause():
	if not _is_running or _is_paused: return
	_is_paused = true
	for spawner in _active_spawners:
		spawner.timer.paused = true

func resume():
	if not _is_running or not _is_paused: return
	_is_paused = false
	for spawner in _active_spawners:
		spawner.timer.paused = false

func stop():
	if not _is_running: return
	_is_running = false
	_clear_active_spawners()

func _start_next_phase():
	_current_phase_index += 1
	if _current_phase_index >=_current_wave.phases.size():
		_is_running = false
		emit_signal("wave_finished")
		return

	var current_phase: WavePhase = _current_wave.phases[_current_phase_index]
	
	if current_phase.spawn_definitions.is_empty():
		_start_next_phase()
		return

	for definition in current_phase.spawn_definitions:
		var timer = Timer.new()
		add_child(timer)
		
		var spawner_data = {
			"definition": definition,
			"remaining_groups": definition.group_count,
			"timer": timer
		}
		_active_spawners.append(spawner_data)
		
		timer.timeout.connect(_on_spawn_timer_timeout.bind(spawner_data))
		timer.start(definition.initial_delay if definition.initial_delay > 0 else 0.001)

func _on_spawn_timer_timeout(spawner_data: Dictionary):
	var definition: EnemySpawnDefinition = spawner_data.definition
	var timer: Timer = spawner_data.timer

	_spawn_group(definition.enemy_scene, definition.group_size, definition.is_boss, definition.cluster_radius)
	spawner_data.remaining_groups -= 1

	if spawner_data.remaining_groups <= 0:
		_remove_spawner(spawner_data)
		if _active_spawners.is_empty() and _is_running:
			_start_next_phase()
	else:
		var randomness = randf_range(-definition.interval_randomness, definition.interval_randomness)
		timer.start(max(0.1, definition.interval + randomness))

func _spawn_group(scene: PackedScene, size: int, is_boss: bool, group_cluster_radius: float):
	if not scene: return
	
	var group_center_pos = _get_random_spawn_position()
	
	for i in range(size):
		var enemy = scene.instantiate()
		get_parent().add_child(enemy)
		
		if enemy is Node2D:
			var offset = Vector2.ZERO
			if group_cluster_radius > 0:
				offset = Vector2(randf_range(-group_cluster_radius, group_cluster_radius), randf_range(-group_cluster_radius, group_cluster_radius))
			
			enemy.global_position = group_center_pos + offset
			
			if is_instance_valid(player):
				enemy.target = player
				enemy.connect("died", _enemy_died)
		
		enemy.add_to_group("enemies")
		if is_boss:
			enemy.add_to_group("bosses")
			
		emit_signal("enemy_spawned", enemy)

func _get_random_spawn_position() -> Vector2:
	if not is_instance_valid(spawn_area):
		push_warning("Spawn Area is not set in EnemyGenerator!")
		return global_position

	var shape_owner = spawn_area.find_child("CollisionShape2D", false)
	if shape_owner and shape_owner.shape is RectangleShape2D:
		var rect_shape: RectangleShape2D = shape_owner.shape
		var rect_extents = rect_shape.size / 2.0
		var random_pos = Vector2(
			randf_range(-rect_extents.x, rect_extents.x),
			randf_range(-rect_extents.y, rect_extents.y)
		)
		return spawn_area.global_position + shape_owner.position + random_pos
	
	return spawn_area.global_position

func _clear_active_spawners():
	for spawner in _active_spawners:
		if is_instance_valid(spawner.timer):
			spawner.timer.queue_free()
	_active_spawners.clear()
	
func _remove_spawner(spawner_data: Dictionary):
	if is_instance_valid(spawner_data.timer):
		spawner_data.timer.queue_free()
	if _active_spawners.has(spawner_data):
		_active_spawners.erase(spawner_data)
		
func _enemy_died(name: String, exp_reward: int):
	enemy_died.emit(name)
	player.add_exp(exp_reward)
