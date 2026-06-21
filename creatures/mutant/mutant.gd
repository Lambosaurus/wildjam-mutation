class_name Mutant
extends CharacterBody2D

enum Action { idle, walk, run, attack }
enum Direction { left, right }

var action_animation_map = {
	Action.idle: Chassis.Animations.IDLE,
	Action.walk: Chassis.Animations.WALK,
	Action.run: Chassis.Animations.RUN,
	Action.attack: Chassis.Animations.ATTACK
}

@export var mutant_type: MutantType

const MELEE_STRIKE = preload('res://entities/strike/strike.tscn')
const SPLATTER = preload('res://entities/pop/pop.tscn')
const NEW_MUTANT = preload('res://creatures/mutant/mutant.tscn')

@export var initial_mutations: Array[Mutation]

@export_group("BOIDS Controls")
@export var BOIDS_REPULSION = 500.0
@export var BOIDS_ATTRACTION = 2000.0
@export var BOIDS_COHESION = 1.0
@export var BOIDS_THRESH_MIN = 200.0
@export var BOIDS_THRESH_MAX = 1000.0

@export var health = 100
@onready var detection_sounds = $DetectionSounds
@onready var mutation_sounds = $MutationSounds
var explode_timeout: float = 3.0


var action = Action.idle;
var action_timeout = 0
var direction = Direction.right

var elevator_attraction: Vector2 = Vector2(0.0, 0.0)

func _ready() -> void:
	
	update_properties()
	
	if initial_mutations:
		for mutation in initial_mutations:
			mutate(mutation)


func update_properties() -> void:
	$TargetSelector.range = max(mutant_type.chase_range, mutant_type.attack_range)
	$ItemSelector.range = mutant_type.eat_range
	$ElevatorSelector.range = mutant_type.elevator_range
	health *= mutant_type.max_health / 100

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func vector_to_direction(x: float) -> Direction:
	return Direction.right if x > 0 else Direction.left

func kill() -> void:
	health = 0.0
	
	var splatter = SPLATTER.instantiate()
	splatter.position = position
	splatter.modulate = Color()
	add_sibling(splatter)
	
	queue_free()

func apply_damage(damage: float) -> bool:
	if damage >= health:
		kill();
		return true
	health -= damage
	return false

var new_target = true

func pick_next_action() -> void:
	var target = $TargetSelector.scan()
	if target:
		if new_target:
			detection_sounds.play()
		new_target = false
		
		var candidate_direction = vector_to_direction(target.global_position.x - global_position.x)
		var dist = global_position.distance_to(target.global_position)
		if dist < mutant_type.attack_range:
			var strike = MELEE_STRIKE.instantiate()
			strike.damage = mutant_type.attack_damage
			strike.flip_h = candidate_direction == Direction.left
			strike.attacker = self
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
	else:
		new_target = true
		
	var item = $ItemSelector.scan()
	if item:
		var candidate_direction = vector_to_direction(item.global_position.x - global_position.x)
		var dist = global_position.distance_to(item.global_position)
		if dist < mutant_type.attack_range:
			if "eat" in item:
				$SlurpSounds.play()
				GameState.biomass += item.eat() * mutant_type.eat_efficiency

			return start_action(
				Action.idle,
				0.25,
				candidate_direction,
			);

		return start_action(
			Action.run,
			0.25,
			candidate_direction,
		);
		
	# Go for elevator if no items or targets
	var elevator = $ElevatorSelector.scan()
	if elevator:
		elevator_attraction = (elevator.global_position - global_position).normalized()
	else:
		elevator_attraction = Vector2(0,0)

	return start_boids_action()
	
func spawn_mutants(count: int, parent: Node2D):
	for i in range(count):
		var new_mutant = NEW_MUTANT.instantiate()
		var new_pos = parent.position
		if count > 1:
			new_pos += Vector2(randf_range(-25,25), randf_range(-25, 0))
		new_mutant.global_position = new_pos
		parent.add_sibling(new_mutant)
	
func on_kill(node: Node2D):
	if mutant_type.spawn_on_kill:
		spawn_mutants(mutant_type.spawn_on_kill, node)

func start_boids_action() -> void:
	# MAGIC NUMBERS BEWARE!
	var swarm = $SwarmDetector
	swarm.compute()
	var force = (swarm.repulsion * BOIDS_REPULSION)	\
		+ (swarm.cohesion * mutant_type.swarm_attraction * BOIDS_COHESION)	\
		+ (elevator_attraction * mutant_type.elevator_attraction * BOIDS_ATTRACTION)

	if abs(force.x) < BOIDS_THRESH_MIN:
		return start_action(
			Action.walk if randf() > 0.75 else Action.idle,
			randf_range(0.25, 1.0),
			direction
			)

	return start_action(
		Action.walk,
		clampf(abs(force.x) / BOIDS_THRESH_MAX, 0.1, 0.9) + randf_range(0, 0.1),
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
	# Revert the health to a 0-100 range.
	health = clamp(health * 100 / mutant_type.max_health, 1, 100)
	mutation_sounds.play()
	$Chassis.apply_mutation(mutation)
	mutant_type = MutantType.new()
	$Chassis.modify_attributes(mutant_type)
	update_properties()
	
	start_action(Action.idle, 0.1, direction)

func has_mutation(mutation: Mutation):
	return $Chassis.has_mutation(mutation)

func update_vision_range():
	var range = $TargetSelector.range
	var scale = range / 100
	$Vision.scale = Vector2(scale, scale) # Vision light is 100px
	pass
	
func on_spawn_timeout():
	spawn_mutants(mutant_type.spawn_on_timeout, self)
	kill()

func _process(delta: float) -> void:
	action_timeout -= delta
	if (action_timeout < 0):
		pick_next_action()
		
	if mutant_type.spawn_on_timeout:
		explode_timeout -= delta
		if explode_timeout < 0:
			on_spawn_timeout()
		
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
	
	if is_on_wall():
		direction = Direction.right if direction == Direction.left else Direction.left
		$Chassis.set_direction(direction)
