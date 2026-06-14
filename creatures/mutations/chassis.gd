class_name Chassis
extends Node2D

const Direction = Mutant.Direction
enum Animations {ATTACK, WALK, RUN, IDLE}

var direction = Direction.left

@onready var slots_dict: Dictionary[Slot.Type, Slot] = {
	Slot.Type.ARMS: $ArmSlot,
	Slot.Type.LEGS: $LegSlot,
	Slot.Type.BODY: $BodySlot
}

func set_direction(dir: Direction):
	if dir == direction: return
	
	direction = dir
	# Flip entire Chassis
	scale.x *= -1

func set_slot(slot: Slot.Type, body_part: BodyPart):
	var old_part = slots_dict[slot].get_child(0)
	slots_dict[slot].add_child(body_part)
	old_part.apply_animation_state_to(body_part)
	old_part.queue_free()
	
func remove_from_slot(slot: Slot.Type):
	slots_dict[slot].get_child(0).queue_free()
	
	
func animate(name: Animations):
	$BodySlot.get_child(0).animate(name)
	$ArmSlot.get_child(0).animate(name)
	$LegSlot.get_child(0).animate(name)
