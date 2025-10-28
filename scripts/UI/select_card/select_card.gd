extends Control

signal select_card_is_open(status: bool)

@export var player: Player

@onready var cards_container = $TextureRect/MarginContainer/HBoxContainer
@onready var stats_panel: StatsPanel = $StatsPanel

var cardScene = preload("res://scenes/UI/select_card/card.tscn")

var is_open: bool = false

func _ready() -> void:
	stats_panel.set_player(player)

func _on_card_selected(card: CardData):
	if player:
		player.apply_card(card)
	close()

func open():
	visible = true
	is_open = true
	stats_panel.open()
	show_cards(3)
	emit_signal("select_card_is_open", is_open)
	InputManager.block_input()

func close():
	visible = false
	is_open = false
	stats_panel.close()
	emit_signal("select_card_is_open", is_open)
	InputManager.unblock_input()

func show_cards(count: int):
	var cards = get_random_cards(3)
	for card in cards:
		card.selected.connect(_on_card_selected)
		cards_container.add_child(card)
		card.play_show_animation()
		
func get_random_cards(count: int) -> Array[Card]:
	clear_children(cards_container)
	var card_path = CardDatabase.get_random_card_paths(count)
	var cards: Array[Card] = []
	for i in count:
		var card = cardScene.instantiate()
		card.data = load(card_path[i])
		cards.append(card)
	return cards

func clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
