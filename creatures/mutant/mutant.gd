extends CharacterBody2D

enum Action { idle, walk, run, attack }
enum Direction { left, right }

@export var WALK_SPEED = 100.0
@export var RUN_SPEED = 200.0
@export var MELEE_DAMAGE = 20.0
@export var MELEE_RANGE = 50.0
const MELEE_STRIKE = preload('res://entities/strike/strike.tscn')

@export var BOIDS_REPULSION = 5000.0
@export var BOIDS_COHESION = 2.0
@export var BOIDS_THRESH_MIN = 50.0
@export var BOIDS_THRESH_MAX = 1000.0

var health = 100
var action = Action.idle;
var action_timeout = 0
var direction = Direction.right
var target: Node2D = null;

func _ready() -> void:
	$HumanDetector.set_range(500)

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func vector_to_direction(x: float) -> Direction:
	return Direction.right if x > 0 else Direction.left

func kill() -> void:
	health = 0.0
	queue_free()

func apply_damage(damage: float) -> bool:
	if damage >= health:
		kill();
		return true
	health -= damage
	return false

func pick_next_action() -> void:
	var candidate_target: Node2D = $HumanDetector.get_closest_target(target)
	if candidate_target:
		
		var candidate_direction = vector_to_direction(candidate_target.global_position.x - global_position.x)
		
		var dist = global_position.distance_to(candidate_target.global_position)
		if dist < MELEE_RANGE:
			var strike = MELEE_STRIKE.instantiate()
			strike.damage = MELEE_DAMAGE
			strike.global_position = candidate_target.global_position
			add_sibling(strike)
			
			return start_action(
				Action.attack,
				0.25,
				candidate_direction,
				candidate_target
			);
		
		return start_action(
			Action.run,
			0.25,
			candidate_direction,
			candidate_target
		);
		
	return start_boids_action()
		
func start_boids_action() -> void:
	# MAGIC NUMBERS BEWARE!
	var swarm = $SwarmDetector
	swarm.compute()
	var force = (swarm.repulsion * BOIDS_REPULSION) + (swarm.cohesion * BOIDS_COHESION)
	
	if abs(force.x) < BOIDS_THRESH_MIN:
		return start_action(
			randi_range(Action.idle, Action.walk) as Action,
			randf_range(0.25, 1.0),
			direction
			)
	
	return start_action(
		Action.walk,
		clampf(abs(force.x) / BOIDS_THRESH_MAX, 0.25, 1.0),
		vector_to_direction(force.x)
	)
	

func start_action(act: Action, time: float, dir: Direction, target: Node2D = null) -> void:
	action = act
	action_timeout = time
	direction = dir
	target = target

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
