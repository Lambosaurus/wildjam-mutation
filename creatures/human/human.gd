extends CharacterBody2D

enum Action { idle, walk, run, attack }
enum Direction { left, right }

const WALK_SPEED = 100.0
const RUN_SPEED = 200.0

var health = 100;
var action = Action.idle;
var action_timeout = 0
var direction = Direction.right

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func pick_next_action() -> void:
	start_action(
		randi_range(Action.idle, Action.walk) as Action,
		randf_range(0.5, 3),
		randi_range(Direction.left, Direction.right) as Direction
	)

func start_action(act: Action, time: float, dir: Direction) -> void:
	action = act
	action_timeout = time
	direction = dir
	
func kill() -> void:
	health = 0.0
	queue_free()

func apply_damage(damage: float) -> bool:
	if damage >= health:
		kill();
		return true
	health -= damage
	return false

func _process(delta: float) -> void:
	action_timeout -= delta
	if (action_timeout < 0):
		pick_next_action()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var x_speed = 0
	if (action == Action.walk):
		x_speed = direction_to_vector(direction, WALK_SPEED)
	elif (action == Action.run):
		x_speed = direction_to_vector(direction, RUN_SPEED)
	
	velocity.x = move_toward(velocity.x, x_speed, RUN_SPEED)

	move_and_slide()
