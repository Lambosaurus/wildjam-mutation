class_name FloorStop
extends Node2D

@onready var collider = $Area2D
@onready var animator = $AnimationPlayer
@onready var door_timer = $DoorTimer

@export var doors_locked = false
var travellers = []
signal door_animation_finished(name: String)
signal traveller_present(body: CharacterBody2D, name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collider.connect("body_entered", _on_mutant_entered)
	animator.connect("animation_finished", _on_animation_finished)
	#door_timer.connect("timeout", _on_door_timer_timeout)
	pass # Replace with function body.

func _on_mutant_entered(body: Node2D):	
	emit_signal("traveller_present", body, name)
#
#
func _on_animation_finished(name: String):
	emit_signal("door_animation_finished", name)
	#if name == 'door_open':
		#
		#door_timer.start(3)
		#unlock doors
