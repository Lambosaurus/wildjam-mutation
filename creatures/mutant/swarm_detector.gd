extends Area2D

@export var cohesion: Vector2 = Vector2(0,0)
@export var repulsion: Vector2 = Vector2(0,0)

func compute():
	repulsion = Vector2(0,0)
	cohesion = Vector2(0,0)
	for body: Node2D in get_overlapping_bodies():
		var delta = body.global_position - global_position
		var swarm_leader: float = body.mutant_type.swarm_leader
		if swarm_leader > 0:
			cohesion += swarm_leader * delta
		
		var magnitude = (delta.length_squared() + 1) ** 1.5 / 1000
		repulsion.x += delta.x / magnitude
		repulsion.y += delta.y / magnitude
