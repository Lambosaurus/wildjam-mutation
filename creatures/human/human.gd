extends CharacterBody2D

enum HumanState { idle, walk, run }
enum Direction { left, right }

const WALK_SPEED = 100.0
const RUN_SPEED = 200.0

var state = HumanState.idle;
var state_timeout = 0
var direction = Direction.right

func pick_new_state() -> void:
	state_timeout = randf_range(0.5, 3)
	state = randi_range(HumanState.idle, HumanState.walk)
	direction = randi_range(Direction.left, Direction.right)

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func _process(delta: float) -> void:
	state_timeout -= delta
	if (state_timeout < 0):
		pick_new_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var x_speed = 0
	if (state == HumanState.walk):
		x_speed = direction_to_vector(direction, WALK_SPEED)
	elif (state == HumanState.run):
		x_speed = direction_to_vector(direction, RUN_SPEED)
	
	velocity.x = move_toward(velocity.x, x_speed, RUN_SPEED)

	move_and_slide()
