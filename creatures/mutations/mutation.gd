class_name Mutation

extends Resource

@export var behaviour: BehaviourModification
@export var slot: Slot.Type
@export var body_part: PackedScene
@export var cost: int
@export var name: String

func modify_attributes():
	
	pass

func get_body_part():
	if not body_part: return null
	
	return body_part.instantiate()
