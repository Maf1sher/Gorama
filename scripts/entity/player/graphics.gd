extends Node2D

@onready var left_hand = $LeftHand
@onready var right_hand = $RightHand

func change_hands_ordering(ani_name: String) -> void:
	if ani_name == "look_left":
		left_hand.z_index = 2
		right_hand.z_index = 0
		swap_hands()
	elif ani_name == "look_right":
		left_hand.z_index = 0
		right_hand.z_index = 2
		swap_hands()
		
func swap_hands() -> void:
	var tmp_position = left_hand.position
	left_hand.position = right_hand.position
	right_hand.position = tmp_position
