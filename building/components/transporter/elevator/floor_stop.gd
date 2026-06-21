class_name FloorStop
extends Node2D

@onready var collider: Area2D = $PixelFloorArea2D
@onready var animator = $AnimationPlayer
@onready var door_timer = $DoorTimer

@export var travel_enabled = true

signal travellers_entered(travellers: Array[Area2D])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.connect("animation_finished", _on_animation_finished)
	if not travel_enabled:
		$PixelFloorArea2D.queue_free()
		return

func is_allowed(body: CharacterBody2D):
	return body is Human or body is Mutant

func _on_animation_finished(anim: String):
	if anim == "closed":
		var travellers = collider.get_overlapping_bodies().filter(is_allowed)
		travellers_entered.emit(travellers)
