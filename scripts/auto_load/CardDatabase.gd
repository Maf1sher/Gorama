extends Node

var card_paths = [
	"res://resources/cards/data/card_test.tres",
	"res://resources/cards/data/card_test2.tres"
]

func get_random_card_paths(count: int) -> Array:
	var result: Array = []
	var total = card_paths.size()

	for i in count:
		var idx = randi_range(0, total - 1)
		result.append(card_paths[idx])

	return result
