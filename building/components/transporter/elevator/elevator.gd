extends Node2D

@export var active_floor_stops: Array[FloorStop]
@export var travel_time: int = 5
@export var wait_time: int = 3
@onready var timer: Timer = $TravelTimeCycle

enum FloorState {DoorsOpening, DoorsOpen, DoorsClosing, DoorsClosed, Travelling}
var state = FloorState.DoorsClosed

# Track which entities are moving to the next floor
var traveller_queue: Array[CharacterBody2D] = []
# Stops entities which have just travelled recently from travelling on the elevator immediately again
var excluded_travellers: Array[CharacterBody2D] = [] 
var target_floor: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.one_shot = true
	timer.connect("timeout", _handle_elevator_travel)
	for idx in len(active_floor_stops):
		var floor_stop = active_floor_stops[idx]
		floor_stop.name = str(idx)
		floor_stop.connect("traveller_present", _handle_traveller_present)
		floor_stop.connect("door_animation_finished", _handle_animation_finished)
	timer.start(travel_time)

func _handle_elevator_travel():
	if state == FloorState.Travelling:
		state = FloorState.DoorsClosed
	if state == FloorState.DoorsClosed:
		state = FloorState.DoorsOpening
		active_floor_stops[target_floor].animator.play("open_door")
		for body in traveller_queue:
			if not is_instance_valid(body):
				continue
			body.global_position = active_floor_stops[target_floor].global_position
			body.start_action(body.Action.walk, 5, body.Direction.left)
		fade_travellers(1, 0.25)
		
	if state == FloorState.DoorsOpen:
		state = FloorState.DoorsClosing
		active_floor_stops[target_floor].animator.play("close_door")

func _handle_animation_finished(name):
	if state == FloorState.DoorsOpening:
		state = FloorState.DoorsOpen
		excluded_travellers = traveller_queue
		traveller_queue = []
		timer.start(wait_time)
		
	if state == FloorState.DoorsClosing:
		fade_travellers(0, 1.0)
		timer.start(travel_time)
		target_floor += 1
		state = FloorState.Travelling
		# Reset excluded travellers once the elevator is moving again to the next floor
		excluded_travellers = []
		
	# Loop back to start
	if target_floor == len(active_floor_stops): 
		target_floor = 0

func _handle_traveller_present(body: CharacterBody2D, floor_name):
	if state == FloorState.DoorsOpen and target_floor == int(floor_name):
		if body in excluded_travellers:
			return
		var tween = create_tween()
		tween.tween_property(body, "global_position", active_floor_stops[target_floor].global_position, 2)
		tween.tween_property(body, "modulate:a", 0, 1)
		body.start_action(body.Action.idle, 20, body.Direction.left)
		traveller_queue.append(body)

func fade_travellers(tween_target, tween_time):
	var tween = create_tween()
	for body in traveller_queue:
		if not is_instance_valid(body):
			continue
		tween.tween_property(body, "modulate:a", tween_target, tween_time)
