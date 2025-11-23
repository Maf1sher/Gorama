class_name StoreInventory
extends PanelContainer

@export var inventory_item_scene: PackedScene
@onready var item_grid = $VBoxContainer/ScrollContainer/ItemGrid

func _ready() -> void:
	generate_shop_inventory(5)

func generate_shop_inventory(amount: int):
	var available_items = ItemDatabase.all_items.duplicate()
	available_items.shuffle()
	var items_to_sell = available_items.slice(0, amount)
	for item in items_to_sell:
		add_item(item)
	
func add_item(item_data: ItemData) -> void:
	var inventory_item = inventory_item_scene.instantiate()
	inventory_item.data = item_data
	item_grid.add_child(inventory_item)
	inventory_item.set_price_visibility(true)
	var success = item_grid.attempt_to_add_item_data(inventory_item)
