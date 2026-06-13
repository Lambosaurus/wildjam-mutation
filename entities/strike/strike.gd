extends Area2D

@export var damage: float = 0.0
@export var duration: float = 0.2
	
func _process(delta: float) -> void:
	if damage > 0:
		for node:Node2D in get_overlapping_bodies():
			node.apply_damage(damage)
			damage = 0
			break
	duration -= delta
	if duration < 0:
		queue_free()
