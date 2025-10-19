extends Map

@export var map_width: int = 20
@export var map_height: int = 10
@export var terrain_id: int = 0
@export var terrain_source_id: int = 0

@onready var map = $Map
@onready var enemy_generator = $EnnemyGenetaor

var next_map_path: String = "res://scenes/maps/SaveZone.tscn"

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
