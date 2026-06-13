extends Area2D

@export var cohesion: Vector2 = Vector2(0,0)
@export var repulsion: Vector2 = Vector2(0,0)

func compute():
	
	repulsion = Vector2(0,0)
	var count = 0
	var avg_pos = Vector2(0,0)
	for body: Node2D in get_overlapping_bodies():
		avg_pos += body.global_position
		count += 1
		
		var delta = global_position - body.global_position
		var dist_sq = delta.length_squared() + 1
		repulsion.x += delta.x / dist_sq
		repulsion.y += delta.y / dist_sq
	
	if count:
		cohesion = (avg_pos / count) - global_position
	else:
		cohesion = Vector2(0,0)
