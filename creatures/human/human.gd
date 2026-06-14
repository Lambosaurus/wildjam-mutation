extends CharacterBody2D

enum Action { idle, walk, run, attack }
enum Direction { left, right }

@export var human_type: HumanType;
const BULLET = preload('res://entities/bullet/bullet.tscn')

@export var health = 100;
var action = Action.idle;
var action_timeout = 0
var direction = Direction.right

func _ready() -> void:
	$TargetSelector.range = max(human_type.attack_range, human_type.flee_range, human_type.chase_range)

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func vector_to_direction(x: float) -> Direction:
	return Direction.right if x > 0 else Direction.left

func pick_next_action() -> void:
	
	var target = $TargetSelector.scan()
	if target:
		var target_position = target.global_position
		var distance = global_position.distance_to(target_position)
		if distance <= human_type.flee_range:
			return start_action(
				Action.run,
				randf_range(0.5, 1.0),
				vector_to_direction(global_position.x - target_position.x)
				)
		
		if distance <= human_type.attack_range:
			spawn_attacks(target_position)
			return 	start_action(
				Action.attack,
				human_type.attack_duration,
				vector_to_direction(target_position.x - global_position.x)
			)
			
		if distance <= human_type.chase_range:
			return 	start_action(
				Action.run,
				0.1,
				vector_to_direction(target_position.x - global_position.x)
			)
	
	# Idle behavior
	return start_action(
		randi_range(Action.idle, Action.walk) as Action,
		randf_range(0.5, 3),
		randi_range(Direction.left, Direction.right) as Direction
	)

func spawn_attacks(target: Vector2):
	for i in range(human_type.bullet_count):
		var bullet = BULLET.instantiate()
		bullet.damage = human_type.bullet_damage
		add_sibling(bullet)
		bullet.position = position
		bullet.set_target(target, human_type.bullet_spread)

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
		x_speed = direction_to_vector(direction, human_type.walk_speed)
	elif (action == Action.run):
		x_speed = direction_to_vector(direction, human_type.run_speed)
	
	velocity.x = move_toward(velocity.x, x_speed, human_type.run_speed)

	move_and_slide()
