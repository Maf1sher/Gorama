class_name PlayerInterface
extends Control

enum PanelPosition { LEFT, CENTER, RIGHT }

signal panel_added(panel: Control)
signal panel_removed(panel: Control)

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
	add_to_group("player_interface")
	character_sheet.connect("item_changed", Callable(player, "_on_item_changed"))
	player.stats_changed.connect(Callable(stats_panel, "_on_stats_changed"))
	stats_panel._on_stats_changed(player.stats)
	add_default_panels()

func open():
	_refresh_layout()
	visible = true
	is_open = true
	InputManager.block_input()

func close():
	visible = false
	is_open = false
	clear_panels()
	add_default_panels()
	InputManager.unblock_input()

func add_default_panels():
	panels[PanelPosition.LEFT].append(PanelData.new(equipment, 3, PanelPosition.LEFT))
	panels[PanelPosition.CENTER].append(PanelData.new(character_sheet, 3, PanelPosition.CENTER))
	panels[PanelPosition.RIGHT].append(PanelData.new(stats_panel, 3, PanelPosition.RIGHT))

func add_panel(control: Control, position: PanelPosition, priority: int = 0):
	var data = PanelData.new(control, priority, position)
	panels[position].append(data)
	_refresh_layout()
	emit_signal("panel_added", control)

func remove_panel(panel: Control):
	for key in panels.keys():
		for data in panels[key]:
			if data.node == panel:
				panels[key].erase(data)
				panel.queue_free()
				_refresh_layout()
				emit_signal("panel_removed", panel)
				return

func _refresh_layout():
	for column in [left_column, center_column, right_column]:
		for child in column.get_children():
			column.remove_child(child)

	for position in panels.keys():
		var sorted = panels[position].duplicate()
		sorted.sort_custom(_sort_by_priority)

		for data in sorted:
			if !is_instance_valid(data.node):
				continue

			if data.node.get_parent():
				data.node.get_parent().remove_child(data.node)

			match position:
				PanelPosition.LEFT:
					left_column.add_child(data.node)
				PanelPosition.CENTER:
					center_column.add_child(data.node)
				PanelPosition.RIGHT:
					right_column.add_child(data.node)


func _sort_by_priority(a: PanelData, b: PanelData) -> bool:
	return a.priority < b.priority

func clear_panels() -> void:
	for column in [left_column, center_column, right_column]:
		for child in column.get_children():
			column.remove_child(child)

	for key in panels.keys():
		panels[key].clear()
