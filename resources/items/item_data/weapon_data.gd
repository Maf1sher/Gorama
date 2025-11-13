class_name WeaponData
extends EquipmentData

@export var socket_layers: Array[SocketLayer] = []

func _init() -> void:
	type = ItemTypes.Type.WEAPON

func generate_socket_tree():
	if socket_layers.size() < 2:
		return
		
	for i in range(socket_layers.size() - 1):
		var bottom_layer: SocketLayer = socket_layers[i]
		var top_layer: SocketLayer = socket_layers[i + 1]
		
		var n = bottom_layer.sockets.size()
		var m = top_layer.sockets.size()
		
		if n == 0 or m == 0:
			continue
			
		var n_float = float(n)
		var m_float = float(m)
		
		for j in range(n):
			var bottom_socket: Socket = bottom_layer.sockets[j]
			
			bottom_socket.connections.clear()
			
			var k_start = floor(j * m_float / n_float)
			var k_end = ceil((j + 1) * m_float / n_float) - 1
			var k_start_int = int(k_start)
			var k_end_int = int(k_end)
			
			for k in range(k_start_int, k_end_int + 1):
				if k >= 0 and k < m:
					var top_socket: Socket = top_layer.sockets[k]
					bottom_socket.connections.append(top_socket)
