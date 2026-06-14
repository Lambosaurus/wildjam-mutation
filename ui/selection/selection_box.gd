class_name SelectionBox

extends Sprite2D

@export var color: Color = Color.GREEN
@export var thickness: float = 2.0
@export var target: CollisionShape2D

func _draw() -> void:
	var rect = target.shape.get_rect()
	
	# Draws an unfilled outline box (Color, Width)
	draw_rect(rect, color, false, thickness)

func _process(delta: float) -> void:
	# Forces the engine to redraw the node if the size changes
	queue_redraw() 
