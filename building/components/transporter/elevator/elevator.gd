extends Node2D

enum Mode { Cyclic }
enum FloorState {DoorsOpening, DoorsOpen, DoorsClosing, DoorsClosed, Travelling}
@export var operating_mode: Mode
@export var floor_stop: PackedScene
@export var num_stops: int
@export var floor_spacing: int = 168 # Fragile, I know. Not sure sure how to do this well.
@export var start_floor_x: int = 0
@export var start_floor_y: int = 0
@export var travel_time: int = 5
@export var wait_time: int = 3

@onready var timer: Timer = $TravelTimeCycle

var state = FloorState.DoorsClosed
var target_floor: int = 0
var travel_target: int = 0
var active_floor_stops: Array

const FLOOR_LABEL = "floor_stop_"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_elevator_stack()

func set_up_elevator_stack():
	timer.one_shot = true
	timer.connect("timeout", _handle_elevator_travel)
	var current_floor_spacing = start_floor_y
	for idx in range(num_stops):
		var current_stop = floor_stop.instantiate()
		current_stop.name = FLOOR_LABEL + str(idx)
		current_stop.connect("travellers_waiting", _assess_floor_access)
		current_stop.connect("door_animation_finished", _handle_animation_finished)
		add_child(current_stop)
		current_stop.global_position = Vector2(start_floor_x, current_floor_spacing)
		active_floor_stops.append(current_stop)
		current_floor_spacing -= floor_spacing  #move up
		print(current_stop.name, Time)
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
