class_name TargetSelector
extends Area2D

@export var range: float = 250:
	set(value):
		$Area.shape.radius = value
		range = value

@export var target_bit = 2:
	set(value):
		collision_mask = 1 << (value - 1)
		$Raycast.collision_mask = 1 | (1 << (value-1))
		target_bit = value

@export var use_body_collider = true:
	set(value):
		$Raycast.collide_with_bodies = value
		$Raycast.collide_with_areas = !value
		
#@export var target: Node2D

func _ready():
	$Area.shape = CircleShape2D.new()

func scan() -> Node2D:
	#if is_instance_valid(target) and overlaps_body(target) and can_see(target):
	#	return target
	
	var best_node = null
	var best_dist_sq = INF
	var object_list = get_overlapping_bodies() if use_body_collider else get_overlapping_areas()
	for node:Node2D in object_list:
		var dist_sq = global_position.distance_squared_to(node.global_position)
		if dist_sq < best_dist_sq and can_see(node):
			best_dist_sq = dist_sq
			best_node = node
	
	#target = best_node
	return best_node

func can_see(target: Node2D) -> bool:
	var ray = $Raycast
	ray.target_position = target.global_position - ray.global_position
	ray.force_raycast_update()
	var collider = ray.get_collider()
	return collider == target
