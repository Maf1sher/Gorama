extends Node

var active_cards: Array = []


func apply_card(card) -> void:
	active_cards.append(card)
	print(active_cards)
	
func clean_cards() -> void:
	active_cards = []
