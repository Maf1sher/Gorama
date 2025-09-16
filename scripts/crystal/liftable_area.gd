extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	print("ok")
	get_parent().queue_free()
