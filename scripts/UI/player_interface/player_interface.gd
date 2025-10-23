extends Control

enum PanelPosition { LEFT, CENTER, RIGHT }

@export var player: Player

@onready var equipment: Equipment = $HBoxContainer/LeftColumn/Equipment
@onready var character_sheet: CharacterSheet = $HBoxContainer/CenterColumn/CharacterSheet
@onready var stats_panel: StatsPanel = $HBoxContainer/RightColumn/StatsPanel
@onready var left_column = $HBoxContainer/LeftColumn
@onready var center_column = $HBoxContainer/CenterColumn
@onready var right_column = $HBoxContainer/RightColumn

var is_open := false

var panels := {
	PanelPosition.LEFT: [],
	PanelPosition.CENTER: [],
	PanelPosition.RIGHT: []
}

class PanelData:
	var node: Control
	var priority: int
	var position: PanelPosition

	func _init(node: Control, priority: int, position: PanelPosition):
		self.node = node
		self.priority = priority
		self.position = position

func _ready() -> void:
	character_sheet.connect("item_changed", Callable(player, "_on_item_changed"))
	panels[PanelPosition.LEFT].append(PanelData.new(equipment, 3, PanelPosition.LEFT))
	panels[PanelPosition.CENTER].append(PanelData.new(character_sheet, 3, PanelPosition.CENTER))
	panels[PanelPosition.RIGHT].append(PanelData.new(stats_panel, 3, PanelPosition.RIGHT))
	
func open():
	visible = true
	is_open = true
	InputManager.block_input()
	
func close():
	visible = false
	is_open = false
	InputManager.unblock_input()
	
func add_panel(scene: PackedScene, position: PanelPosition, priority: int = 0) -> Control:
	var panel = scene.instantiate()
	var data = PanelData.new(panel, priority, position)
	panels[position].append(data)
	_refresh_layout()
	return panel

func remove_panel(panel: Control):
	for key in panels.keys():
		for data in panels[key]:
			if data.node == panel:
				panels[key].erase(data)
				panel.queue_free()
				_refresh_layout()
				return

func _refresh_layout():
	for column in [left_column, center_column, right_column]:
		for child in column.get_children():
			column.remove_child(child)
			child.queue_free()

	for position in panels.keys():
		var sorted = panels[position].duplicate()
		sorted.sort_custom(_sort_by_priority)
		for data in sorted:
			match position:
				PanelPosition.LEFT:
					left_column.add_child(data.node)
				PanelPosition.CENTER:
					center_column.add_child(data.node)
				PanelPosition.RIGHT:
					right_column.add_child(data.node)

func _sort_by_priority(a: PanelData, b: PanelData) -> bool:
	return a.priority < b.priority
