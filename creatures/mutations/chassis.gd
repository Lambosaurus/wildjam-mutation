class_name Chassis
extends Node2D

const Direction = Mutant.Direction
enum Animations {ATTACK, WALK, RUN, IDLE}

var direction = Direction.left

@onready var slots_dict: Dictionary[Slot.Type, Slot] = {
	Slot.Type.ARMS: $ArmSlot,
	Slot.Type.LEGS: $LegSlot,
	Slot.Type.BODY: $BodySlot,
	Slot.Type.HEAD: $HeadSlot
}

func set_direction(dir: Direction):
	if dir == direction: return
	
	direction = dir
	# Flip entire Chassis
	scale.x *= -1

func apply_mutation(mutation: Mutation):
	slots_dict[mutation.slot].apply_mutation(mutation)
	
func modify_attributes(mutant_type: MutantType) -> void:
	for slot in slots_dict.values():
		if slot.mutation:
			slot.mutation.modify_attributes(mutant_type)
	
func animate(name: Animations):
	$BodySlot.body_part.animate(name)
	$ArmSlot.body_part.animate(name)
	$LegSlot.body_part.animate(name)
