extends Control

@onready var cards_container = $TextureRect/MarginContainer/HBoxContainer

var cardScene = preload("res://scenes/UI/select_card/card.tscn")

var is_open: bool = false

func _ready() -> void:
	for i in 3:
		var card = cardScene.instantiate()
		card.card_name = str("card ", i+1)
		card.texture = load("res://assests/sprites/cards/example1.png")
		card.clicked.connect(_on_card_clicked)
		cards_container.add_child(card)
		
func _on_card_clicked(card):
	print(card.card_name)
	close()
	
func open():
	visible = true
	is_open = true
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	InputManager.unblock_input()
	
