extends CanvasLayer

@onready var inventory = $Inventory

func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("open_inventory"):
		if inventory.is_open:
			inventory.close()
		else:
			inventory.open()
			inventory.grab_focus()
