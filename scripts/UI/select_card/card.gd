class_name Card
extends Control

signal clicked(card)

@export var data: CardData

@onready var effect_sceen = preload("res://scenes/UI/select_card/effect.tscn")

@onready var textureRect = $Texture
@onready var effects_container = $MarginContainer/VBoxContainer

func _ready() -> void:
	if data:
		textureRect.texture = data.texture
		set_card_effects(data.effects)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_left_click"):
		CardManager.apply_card(data)
		emit_signal("clicked", self)
		
func set_card_effects(effects: Array) -> void:
	for effect in effects:
		var new_effect = effect_sceen.instantiate()
		new_effect.set_effect_text(effect.stat, effect.value)
		effects_container.add_child(new_effect)
