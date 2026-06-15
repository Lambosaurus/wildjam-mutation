extends Node2D


@onready var collider = $Area2D
@onready var animator = $AnimationPlayer
@onready var door_timer = $DoorTimer
var doors_locked = true
signal travellers_waiting(name)
signal door_animation_finished(name)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door_timer.one_shot = true
	collider.connect("body_entered", _on_mutant_entered)
	animator.connect("animation_finished", _on_animation_finished)
	#door_timer.connect("timeout", _on_door_timer_timeout)
	pass # Replace with function body.

func _on_mutant_entered(body: Node2D):
	if doors_locked:
		return
	emit_signal("travellers_waiting", name)
	#animator.play("door_open")
#
#
func _on_animation_finished(name: String):
	print('floor stop animation complete')
	emit_signal("door_animation_finished", name)
	#if name == 'door_open':
		#
		#door_timer.start(3)
		#unlock doors
#
#func _on_door_timer_timeout():
	#print('in here')
	#doors_locked = false
	#animator.play_backwards("door_open")
