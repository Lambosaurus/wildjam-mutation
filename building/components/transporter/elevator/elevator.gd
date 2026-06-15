extends Node2D

enum Mode { Cyclic }
enum FloorState {DoorsOpening, DoorsOpen, DoorsClosing, DoorsClosed, Travelling}
@export var operating_mode: Mode
@export var travel_time: int = 5
@export var wait_time: int = 3

@onready var timer: Timer = $TravelTimeCycle

var state = FloorState.DoorsClosed
var target_floor: int = 0
var travel_target: int = 0
@export var active_floor_stops: Array[FloorStop]

const FLOOR_LABEL = "floor_stop_"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_elevator_stack()

func set_up_elevator_stack():
	timer.one_shot = true
	timer.connect("timeout", _handle_elevator_travel)
	for idx in len(active_floor_stops):
		var floor_stop = active_floor_stops[idx]
		floor_stop.name = FLOOR_LABEL + str(idx)
		floor_stop.connect("travellers_waiting", _assess_floor_access)
		floor_stop.connect("door_animation_finished", _handle_animation_finished)

		print(floor_stop.name, Time)
	timer.start(travel_time)

func _handle_elevator_travel():
	print('Timer expired. Current State: ', state)
	if state == FloorState.Travelling:
		state = FloorState.DoorsClosed
	if state == FloorState.DoorsClosed:
		state = FloorState.DoorsOpening
		active_floor_stops[target_floor].animator.play("door_open")
	
	if state == FloorState.DoorsOpen:
		state = FloorState.DoorsClosing
		active_floor_stops[target_floor].animator.play_backwards("door_open")


func _handle_animation_finished(name):
	print("Animation done :", name)
	if state == FloorState.DoorsOpening:
		state = FloorState.DoorsOpen
		timer.start(wait_time)
	if state == FloorState.DoorsClosing:
		timer.start(travel_time)
		target_floor += 1
		state = FloorState.Travelling
		# start floor travel timer
		if target_floor == len(active_floor_stops): # loop back to start
			target_floor = 0

func _assess_floor_access(floor_name):
	print("processing: ", floor_name)
