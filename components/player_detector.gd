class_name PlayerDetector
extends Area2D

signal player_detection(in_area: bool)

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body) -> void:
	if body.name == "Player":
		player_detection.emit(true)
		
func _on_body_exited(body) -> void:
	if body.name == "Player":
		player_detection.emit(false)
