extends Node2D

@onready var orc: PackedScene = preload("res://scenes/Orc.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 5:
		await get_tree().create_timer(1).timeout
		var orc = orc.instantiate()
		orc.position = Vector2(randi_range(-100,100),randi_range(-100,100))
		add_child(orc)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
