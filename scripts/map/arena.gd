extends Map

@export var map_width: int = 20
@export var map_height: int = 10
@export var terrain_id: int = 0
@export var terrain_source_id: int = 0

@onready var map = $Map
@onready var enemy_generator = $EnnemyGenetaor
@onready var counter = $Counter

var next_map_path: String = "res://scenes/maps/SaveZone.tscn"

var enemy_counter: int = 0
var enemy_generator_active: bool = true

func _ready():
	generate_rect_terrain(Vector2i(0,0), map_width, map_height, terrain_source_id, terrain_id)
	enemy_generator.player = player

func generate_rect_terrain(center: Vector2i, width: int, height: int, src_id: int, terr_id: int) -> void:
	map.clear()
	var positions: Array = []
	for x in range(center.x - ceil((width+2)/2.0), center.x + floor((width+2)/2.0)):
		for y in range(center.y - ceil((height+2)/2.0), center.y + floor((height+2)/2.0)):
			positions.append(Vector2i(x, y))
	map.set_cells_terrain_connect(positions, src_id, terr_id, true)

func check_wave_finished() -> void:
	if !enemy_generator_active and enemy_counter <= 0:
		counter.start_timer()

func _on_ennemy_genetaor_wave_finished() -> void:
	enemy_generator_active = false

func _on_ennemy_genetaor_enemy_spawned(_enemy_instance: Enemy) -> void:
	enemy_counter+=1
	check_wave_finished()

func _on_ennemy_genetaor_enemy_died(_name: String) -> void:
	enemy_counter-=1
	check_wave_finished()

func _on_counter_counting_completed() -> void:
	change_map.emit(next_map_path)
	GameManager.increment_wave_number()
