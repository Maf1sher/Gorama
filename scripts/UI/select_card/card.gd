class_name Card
extends Control

signal clicked(card)

@export var card_name: String
@export var texture: Texture2D

@onready var textureRect = $Texture

func _ready() -> void:
	textureRect.texture = texture

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_left_click"):
		emit_signal("clicked", self)
