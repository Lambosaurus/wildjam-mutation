class_name SelectionArea
extends Area2D

@export_group("Action")
@export var action_target: Node
@export_group("Highlighting")
@export var highlight_target: Node2D
@export var highlight_color: Color

var _highlight_node: Node

func _ready():
	# Connect mouse input signal to detect clicks
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		SelectionManager.clicked_node(self, event.button_index)
		
func get_selectable_node():
	return highlight_target
	
func highlight(on: bool = true):
	if not on and _highlight_node:
		_highlight_node.queue_free()
	elif on and not _highlight_node:
		_highlight_node = SelectionBox.new()
		_highlight_node.target = highlight_target
		_highlight_node.color = highlight_color
		add_child(_highlight_node)
