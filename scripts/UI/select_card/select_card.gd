extends Control

signal select_card_is_open(status: bool)

@onready var cards_container = $TextureRect/MarginContainer/HBoxContainer

var cardScene = preload("res://scenes/UI/select_card/card.tscn")

var is_open: bool = false
		
func _on_card_clicked(card):
	close()
	
func open():
	visible = true
	is_open = true
	get_random_cards(3)
	emit_signal("select_card_is_open", is_open)
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	emit_signal("select_card_is_open", is_open)
	InputManager.unblock_input()
	
func get_random_cards(count: int) -> void:
	clear_children(cards_container)
	var card_path = CardDatabase.get_random_card_paths(count)
	for i in count:
		var card = cardScene.instantiate()
		card.data = load(card_path[i])
		card.clicked.connect(_on_card_clicked)
		cards_container.add_child(card)
		
func clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
