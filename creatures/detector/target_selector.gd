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
		
@export var target: Node2D

func _ready():
	$Area.shape = CircleShape2D.new()

func scan() -> Node2D:
	if is_instance_valid(target) and overlaps_body(target) and can_see(target):
		# Do not change targets if we can still see the old one
		return target
	
	var best_node = null
	var best_dist_sq = 1e9
	for node:Node2D in get_overlapping_bodies():
		var dist_sq = global_position.distance_squared_to(node.global_position)
		if dist_sq < best_dist_sq and can_see(node):
			best_dist_sq = dist_sq
			best_node = node
			
	target = best_node
	return target

func can_see(target: Node2D) -> bool:
	var ray = $Raycast
	ray.target_position = target.global_position - ray.global_position
	ray.force_raycast_update()
	var collider = ray.get_collider()
	return collider == target
