class_name Mutation

extends Resource

@export var behaviour: BehaviourModification
@export var slot: Slot.Type
@export var body_part: PackedScene

func modify_attributes():
	# TODO
	pass

func get_body_part():
	if not body_part: return null
	
	return body_part.instantiate()
