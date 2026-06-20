class_name AnimatedSkeleton
extends Skeleton2D

@export var animation: AnimationPlayer

func play(anim: String):
	animation.play(anim)
