extends RigidBody2D

@export var x_scatter: float = 10

func _ready() -> void:
	linear_velocity.x = randf_range(-x_scatter,x_scatter)
