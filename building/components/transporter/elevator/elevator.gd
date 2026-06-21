extends Node2D

@export var elevator_interior: Node2D
@export var travel_time: int = 5
@export var wait_time: int = 3
@onready var travel_timer: Timer = $TravelTimeCycle
@onready var wait_timer: Timer = $WaitTimer

enum Direction {UP, DOWN}

var _active_floor_stops: Array[Node]
# Track which entities are moving to the next floor
var traveller_queue: Array[Node2D] = []

var current_floor = 0
var current_direction = Direction.UP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if elevator_interior: elevator_interior.visible = false
	detect_floor_stops()

	wait_timer.timeout.connect(handle_new_travellers)
	travel_timer.timeout.connect(eject_travellers)

	current_floor_stop().open()
	wait_timer.start(wait_time)

func detect_floor_stops():
	for child in get_children():
		if child is PixelFloorStop:
			_active_floor_stops.append(child)

func teleport_traveler_to_elevator_interior(traveler):
	traveler.global_position = elevator_interior.global_position

func fade_traveller(traveller, tween_target, tween_time):
	if not is_instance_valid(traveller): return

	var tween = create_tween()
	tween.tween_property(traveller, "modulate:a", tween_target, tween_time)
	tween.play()

	return tween

func handle_new_travellers():
	var current_stop = current_floor_stop()
	traveller_queue = current_stop.get_travellers()
	for traveller in traveller_queue:
		if current_direction == Direction.DOWN and traveller is Mutant: continue

		var tween = fade_traveller(traveller, 0, 0.25)
		if elevator_interior: tween.finished.connect(teleport_traveler_to_elevator_interior.bind(traveller))

	current_floor_stop().close()
	travel_timer.start(travel_time)

func eject_travellers():
	next_floor()
	for traveller in traveller_queue:
		move_traveller_to_new_floor(traveller)

	traveller_queue = []
	current_floor_stop().open()
	wait_timer.start(wait_time)

func next_floor():
	var floor_count = len(_active_floor_stops)
	match current_direction:
		Direction.UP:
			current_floor += 1
			if current_floor >= floor_count:
				current_floor -= 2
				current_direction = Direction.DOWN
		Direction.DOWN:
			current_floor -= 1
			if current_floor < 0:
				current_floor += 2
				current_direction = Direction.UP

	return current_floor

func move_traveller_to_new_floor(traveller):
	if not is_instance_valid(traveller): return

	var stop = current_floor_stop()
	traveller.global_position = stop.global_position
	fade_traveller(traveller, 1, 0.25)
	traveller.start_action(traveller.Action.idle, 0, traveller.Direction.left)

func current_floor_stop():
	if len(_active_floor_stops) <= current_floor: return

	return _active_floor_stops[current_floor]
