extends Area2D

signal select

func _ready():
	# Connect mouse input signal to detect clicks
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		select.emit(self)
		print("Selected")
