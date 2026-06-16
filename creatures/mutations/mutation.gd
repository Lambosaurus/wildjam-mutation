class_name Mutation

extends Resource

@export var slot: Slot.Type
@export var body_part: PackedScene
@export var mutation_type: MutationType
@export var cost: int
@export var name: String

func modify_attributes(mt: MutantType):
	if mutation_type:
		mutation_type.apply(mt)

func get_body_part():
	if not body_part:
		return null
	return body_part.instantiate()
