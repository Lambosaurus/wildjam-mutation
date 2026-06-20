class_name BodyPart
extends Node2D

@export var skeleton: AnimatedSkeleton

const animation_map = {
	Chassis.Animations.ATTACK: "attack",
	Chassis.Animations.WALK: "walk",
	Chassis.Animations.RUN: "run",
	Chassis.Animations.IDLE: "idle"
}

func animate(chassis_animation: Chassis.Animations):
	if skeleton.animation:
		var animation_name = animation_map[chassis_animation]
		skeleton.animation.play(animation_name)
		
func apply_animation_state_to(body_part: BodyPart):
	if not skeleton.animation or not skeleton.animation.is_playing(): return
	
	body_part.skeleton.animation.play(skeleton.animation.current_animation)
	body_part.skeleton.animation.seek(skeleton.animation.current_animation_position)
	

func get_current_animation():
	return skeleton.animation.current_animation
