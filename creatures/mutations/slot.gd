class_name Slot

extends Node2D

enum Type {ARMS, LEGS, BODY}

@onready var body_part: BodyPart = get_child(0)
var mutation: Mutation

func apply_mutation(mut: Mutation):
	var old_part = body_part
	
	mutation = mut
	body_part = mut.get_body_part()
	
	old_part.apply_animation_state_to(body_part)
	old_part.queue_free()
	add_child(body_part)
	
func remove_mutation() -> void:
	body_part.queue_free()
	mutation = null
