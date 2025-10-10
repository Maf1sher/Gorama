extends PanelContainer

@export var items: Array[ItemData] = []
@export var inventory_item_scene: PackedScene
@onready var item_grid = $ItemGrid

func _ready() -> void:
	for i in items:
		add_item(i)
	ItemDragManager.register_fast_move_target("equipment", Callable(self, "fast_move"))

func _exit_tree() -> void:
	ItemDragManager.unregister_fast_move_target("equipment")

func add_item(item_data: ItemData) -> void:
	var inventory_item = inventory_item_scene.instantiate()
	inventory_item.data = item_data
	item_grid.add_child(inventory_item)
	var success = item_grid.attempt_to_add_item_data(inventory_item)

func fast_move(item: Node) -> bool:
	return item_grid.fast_move_place_item(item)
