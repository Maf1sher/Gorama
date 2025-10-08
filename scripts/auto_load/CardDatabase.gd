extends Node

var card_pools = {
	"Common": [
		"res://resources/cards/data/card_test.tres",
		"res://resources/cards/data/card_test2.tres",
		"res://resources/cards/data/card_test3.tres",
	],
	"Rare": [
		"res://resources/cards/data/card_test3.tres",
	],
	"Epic": [
		"res://resources/cards/data/card_test3.tres",
	],
	"Legendary": [
		"res://resources/cards/data/card_test3.tres",
	],
	"Mythic": [
		"res://resources/cards/data/card_test3.tres",
	]
}

var rarity_weights = {
	"Common": 50.0,
	"Rare": 36.0,
	"Epic": 10.0,
	"Legendary": 3.0,
	"Mythic": 1.0
}

func get_random_card_paths(count: int) -> Array:
	var result: Array = []

	for i in count:
		var rarity = _get_random_rarity()
		var cards_in_rarity = card_pools[rarity]
		if cards_in_rarity.is_empty():
			continue

		var random_card = cards_in_rarity.pick_random()
		result.append(random_card)

	return result
	
func _get_random_rarity() -> String:
	var total_weight = 0.0
	for w in rarity_weights.values():
		total_weight += w

	var random_pick = randf() * total_weight
	var cumulative = 0.0

	for rarity in rarity_weights.keys():
		cumulative += rarity_weights[rarity]
		if random_pick <= cumulative:
			return rarity

	return "Common"
