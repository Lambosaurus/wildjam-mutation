extends CharacterBody2D

enum MutantState { idle, walk, run }
enum Direction { left, right }

const WALK_SPEED = 100.0
const RUN_SPEED = 200.0

var state = MutantState.idle;
var state_timeout = 0
var direction = Direction.right
var target: Node2D = null;

func _ready() -> void:
	$HumanDetector.set_range(500)

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func vector_to_direction(x: float) -> Direction:
	return Direction.right if x > 0 else Direction.left

func pick_new_state() -> void:
	var candidate_target = $HumanDetector.get_closest_target()
	if candidate_target:
		target = candidate_target
		state = MutantState.run
		direction = vector_to_direction(target.position.x - position.x)
		state_timeout = 0.25
	else:
		target = null
		state = MutantState.walk
		direction = randi_range(Direction.left, Direction.right) as Direction
		state_timeout = randf_range(0.25, 2.0)

func _process(delta: float) -> void:
	state_timeout -= delta
	if (state_timeout < 0):
		pick_new_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var x_speed = 0
	if (state == MutantState.walk):
		x_speed = direction_to_vector(direction, WALK_SPEED)
	elif (state == MutantState.run):
		x_speed = direction_to_vector(direction, RUN_SPEED)
	
	velocity.x = move_toward(velocity.x, x_speed, RUN_SPEED)

	move_and_slide()
