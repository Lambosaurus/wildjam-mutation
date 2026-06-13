extends Area2D

func set_range(r: float) -> void:
	$CollisionShape2D.shape.radius = r

func get_closest_target(prior:Node2D = null) -> Node2D:
	if prior and overlaps_body(prior) and can_see(prior):
		return prior
	
	var best_node = null
	var best_dist_sq = 1e9
	for node:Node2D in get_overlapping_bodies():
		var dist_sq = position.distance_squared_to(node.position)
		if dist_sq < best_dist_sq and can_see(node):
			best_dist_sq = dist_sq
			best_node = node
			
	return best_node

func can_see(target: Node2D) -> bool:
	var ray = $RayCast2D
	ray.target_position = target.global_position - ray.global_position
	ray.force_raycast_update()
	var hit = ray.get_collider() == target
	return hit
