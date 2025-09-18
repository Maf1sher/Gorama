extends Node2D

@onready var left_hand = $LeftHand
@onready var right_hand = $RightHand


func change_hands_ordering(ani_name: String) -> void:
	if ani_name == "look_left":
		left_hand.z_index = 2
		left_hand.change_offset()
		right_hand.z_index = 0
		right_hand.change_offset()
	elif ani_name == "look_right":
		left_hand.z_index = 0
		left_hand.change_offset()
		right_hand.z_index = 2
		right_hand.change_offset()
