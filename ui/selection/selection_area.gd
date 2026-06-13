class_name SelectionArea
extends Area2D

@onready var parent: CanvasItem = get_parent()

@export var highlight_shader: ShaderMaterial

func _ready():
	# Connect mouse input signal to detect clicks
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		SelectionManager.clicked_node(self, event.button_index)
		
func get_selectable_node():
	return parent
