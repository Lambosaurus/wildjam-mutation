class_name FloorStop
extends Node2D

@onready var collider = $PixelFloorArea2D
@onready var animator = $AnimationPlayer
@onready var door_timer = $DoorTimer

@export var travel_enabled = true
var travellers = []
signal door_animation_finished(name: String)
signal traveller_present(body: CharacterBody2D, name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.connect("animation_finished", _on_animation_finished)
	
	if !travel_enabled:
		return
	collider.connect("body_entered", _on_mutant_entered)
	#door_timer.connect("timeout", _on_door_timer_timeout)
	pass # Replace with function body.

func _on_mutant_entered(body: CharacterBody2D):
	emit_signal("traveller_present", body, name)

func _on_animation_finished(name: String):
	emit_signal("door_animation_finished", name)
