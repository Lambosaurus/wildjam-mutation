class_name BodyPart
extends Node2D

@onready var skeleton: Skeleton2D
@onready var animation: AnimationPlayer

func animate(name: String):
	animation.play(name)
	pass
