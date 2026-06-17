extends RigidBody2D

@export var x_scatter: float = 10
@export var biomass: float = 10

func _ready() -> void:
	linear_velocity.x = randf_range(-x_scatter,x_scatter)
	
func eat() -> float:
	queue_free()
	var b = biomass
	biomass = 0
	return b
