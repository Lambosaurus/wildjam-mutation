extends Area2D

func set_range(r: float) -> void:
	$CollisionShape2D.shape.radius = r

func get_closest_target() -> Node2D:
	var best_node = null
	var best_dist_sq = 1e9
	for node:Node2D in get_overlapping_bodies():
		var dist_sq = position.distance_squared_to(node.position)
		if dist_sq < best_dist_sq:
			best_dist_sq = dist_sq
			best_node = node
	return best_node
