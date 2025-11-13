extends VBoxContainer

@onready var socket_layer_sceen = preload("res://scenes/UI/player_interface/item_info_panel/socket_layer_panel.tscn")
@export var socket_sceen: PackedScene

var socket_map: Dictionary = {}
var socket_layers: Array[SocketLayer]

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		await get_tree().process_frame
		queue_redraw()

func generate_socket_tree(socket_layers: Array[SocketLayer]) -> void:
	if !socket_layers:
		return
	
	clear_socket_tree()
	
	self.socket_layers = socket_layers
	for layer in socket_layers:
		var layer_instance = socket_layer_sceen.instantiate()
		add_child(layer_instance)
		for socket in layer.sockets:
			var socket_instance = socket_sceen.instantiate()
			layer_instance.add_child(socket_instance)
			socket_map[socket] = socket_instance
	
	call_deferred("queue_redraw")
	
func _draw():
	var line_color = Color.BLACK
	var line_width = 1.0
	var self_global_pos = global_position
	
	if socket_layers:
		for layer in socket_layers:
			for socket in layer.sockets:
				var bottom_panel = socket_map[socket]
				var start_pos = bottom_panel.global_position + bottom_panel.size / 2
				for connection in socket.connections:
					var upper_panel = socket_map[connection]
					var end_pos = upper_panel.global_position + upper_panel.size / 2
					var start_pos_local = start_pos - self_global_pos
					var end_pos_local = end_pos - self_global_pos
					
					draw_line(start_pos_local, end_pos_local, line_color, line_width)

func clear_socket_tree() -> void:
	socket_layers = []
	socket_map.clear()
	for child in get_children():
		child.queue_free()
