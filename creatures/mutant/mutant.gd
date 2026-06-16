class_name Mutant
extends CharacterBody2D

enum Action { idle, walk, run, attack }
enum Direction { left, right }

var action_animation_map = {
	Action.idle: Chassis.Animations.IDLE,
	Action.walk: Chassis.Animations.WALK,
	Action.run: Chassis.Animations.WALK,
	Action.attack: Chassis.Animations.ATTACK
}

var attributes = {
	"agression": 0.0
}

@export var mutant_type: MutantType

const MELEE_STRIKE = preload('res://entities/strike/strike.tscn')

@export_group("BOIDS Controls")
@export var BOIDS_REPULSION = 1000.0
@export var BOIDS_COHESION = 2.0
@export var BOIDS_THRESH_MIN = 50.0
@export var BOIDS_THRESH_MAX = 1000.0

@onready var health = mutant_type.max_health
var action = Action.idle;
var action_timeout = 0
var direction = Direction.right

func _ready() -> void:
	$TargetSelector.range = max(mutant_type.chase_range, mutant_type.attack_range)

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
	var target = $TargetSelector.scan()
	if target:
		var candidate_direction = vector_to_direction(target.global_position.x - global_position.x)
		var dist = global_position.distance_to(target.global_position)
		if dist < mutant_type.attack_range:
			var strike = MELEE_STRIKE.instantiate()
			strike.damage = mutant_type.attack_damage
			add_sibling(strike)
			strike.global_position = target.global_position

			return start_action(
				Action.attack,
				0.25,
				candidate_direction,
			);

		return start_action(
			Action.run,
			0.25,
			candidate_direction,
		);

	return start_boids_action()

func start_boids_action() -> void:
	# MAGIC NUMBERS BEWARE!
	var swarm = $SwarmDetector
	swarm.compute()
	var force = (swarm.repulsion * BOIDS_REPULSION) + (swarm.cohesion * BOIDS_COHESION)

	if abs(force.x) < BOIDS_THRESH_MIN:
		return start_action(
			Action.walk if randf() > 0.75 else Action.idle,
			randf_range(0.25, 1.0),
			direction
			)

	return start_action(
		Action.walk,
		clampf(abs(force.x) / BOIDS_THRESH_MAX, 0.1, 1.0),
		vector_to_direction(force.x)
	)


func start_action(act: Action, time: float, dir: Direction, target: Node2D = null) -> void:
	action = act
	action_timeout = time
	direction = dir
	target = target

	# Handle Chassis updates
	$Chassis.set_direction(dir)
	$Chassis.animate(action_animation_map[action])

func mutate(mutation: Mutation):
	$Chassis.apply_mutation(mutation)
	mutant_type = MutantType.new()
	$Chassis.modify_attributes(mutant_type)
	

func update_vision_range():
	var range = $TargetSelector.range
	var scale = range / 100
	$Vision.scale = Vector2(scale, scale) # Vision light is 100px
	pass

func _process(delta: float) -> void:
	action_timeout -= delta
	if (action_timeout < 0):
		pick_next_action()
		
	update_vision_range()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var x_speed = 0
	if (action == Action.walk):
		x_speed = direction_to_vector(direction, mutant_type.walk_speed)
	elif (action == Action.run):
		x_speed = direction_to_vector(direction, mutant_type.run_speed)

	velocity.x = move_toward(velocity.x, x_speed, mutant_type.run_speed)

	move_and_slide()
