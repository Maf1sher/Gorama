extends Control

@export var icon: Texture2D
@export var stat_name: String
@export var value: int

@onready var iconNode = $Icon
@onready var nameNode = $Name
@onready var valuerNode = $Value

func _ready() -> void:
	iconNode.texture = icon
	nameNode.text = stat_name
	valuerNode.text = str(value)
	
func set_value(value: int) -> void:
	valuerNode.text = str(value)
