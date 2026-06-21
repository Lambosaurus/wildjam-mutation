class_name PixelFloorStop
extends Node2D

@onready var collider: Area2D = $TravellerArea
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D

@export var travel_enabled = true

func open():
	animator.play("open")
	
func close():
	animator.play("close")

func is_allowed(body: CharacterBody2D) -> bool:
	return body is Human or body is Mutant
	
func get_travellers():
	var arr = [] as Array[Node2D]
	if not travel_enabled: return arr
	
	for body in collider.get_overlapping_bodies():
		if is_allowed(body):
			arr.append(body)
			
	return arr

func _on_traveller_area_body_entered(body):
	if body is Mutant or body is Human:
		body.can_elevator()
