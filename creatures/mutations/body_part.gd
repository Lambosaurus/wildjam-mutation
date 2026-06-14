class_name BodyPart
extends Node2D

@export var skeleton: Skeleton2D
@export var animation: AnimationPlayer

const animation_map = {
	Chassis.Animations.ATTACK: "attack",
	Chassis.Animations.WALK: "walk",
	Chassis.Animations.RUN: "run",
	Chassis.Animations.IDLE: "idle"
}

func animate(chassis_animation: Chassis.Animations):
	if animation:
		var animation_name = animation_map[chassis_animation]
		animation.play(animation_name)
		
func apply_animation_state_to(body_part: BodyPart):
	if not animation or not animation.is_playing(): return
	
	body_part.animation.play(animation.current_animation)
	body_part.animation.seek(animation.current_animation_position)
	

func get_current_animation():
	return animation.current_animation
