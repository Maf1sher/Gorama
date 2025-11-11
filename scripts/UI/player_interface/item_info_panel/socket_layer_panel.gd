extends HBoxContainer

@onready var socket_sceen = preload("res://scenes/UI/player_interface/item_info_panel/socket_panel.tscn")

#func generate_sockets(count: int) -> void:
	#for i in count:
		#var instace = socket_sceen.instantiate()
		#add_child(instace)
		
func add_socket() -> void:
	add_child(socket_sceen.instantiate())
