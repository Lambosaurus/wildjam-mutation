class_name Chassis
extends Node2D

@export var arms_to_replace: BodyPart

func _process(delta):
	if Input.is_action_just_pressed("swap_arms"):
		attach_arm()

func attach_arm():
	$ArmSlot.get_child(0).replace_by(arms_to_replace)
	pass
	
func animate(name: String):
	$BodySlot.get_child(0).animate(name)
	$ArmSlot.get_child(0).animate(name)
	$LegSlot.get_child(0).animate(name)
