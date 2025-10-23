extends CanvasLayer

@onready var player_interface = $PlayerInterface

#func _ready():
	#player_interface.close()

func _input(event):
	if event.is_action_pressed("open_inventory"):
		if player_interface.is_open:
			player_interface.close()
		else:
			player_interface.open()
			player_interface.grab_focus()
