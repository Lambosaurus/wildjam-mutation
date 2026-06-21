class_name Human
extends CharacterBody2D

enum Action { idle, walk, run, attack }
enum Direction { left, right }

@export var human_type: HumanType;
const BULLET = preload('res://entities/bullet/bullet.tscn')
const GIBLET = preload('res://entities/giblet/giblet.tscn')
const SPLATTER =  preload('res://entities/pop/pop.tscn')

const POLL_DURATION = 0.05

const CHAT_CHANCE = 0.1
const CHAT_TIMEOUT_MIN = 5
const CHAT_TIMEOUT_MAX = 15

const ANIMATIONS: Dictionary = {
	Action.idle: "idle",
	Action.walk: "walk",
	Action.run: "run",
	Action.attack: "attack",
}

var health = 0;
var action = Action.idle;
var action_timeout = 0
var direction = Direction.right
var poll_timeout = POLL_DURATION

func _ready() -> void:
	run_chat_timer()
	$TargetSelector.range = max(human_type.shoot_range, human_type.flee_range, human_type.melee_range, human_type.chase_range)
	$Spritesheet.sprite_frames = human_type.sprites
	health = human_type.max_health
	

func elevated():
	$ElevatorTimer.start()
	
func will_elevate_direction(_dir):
	return true
	
func can_elevator():
	if $ElevatorTimer.is_stopped() and action == Action.idle:
		start_action(
			Action.idle,
			20,
			direction
		)
		
		return true
	return false

func direction_to_vector(dir: Direction, scalar: float = 1.0) -> float:
	return scalar if dir == Direction.right else -scalar

func vector_to_direction(x: float) -> Direction:
	return Direction.right if x > 0 else Direction.left

func pick_next_action(is_idle: bool = false) -> void:
	var target = $TargetSelector.scan()
	if target:
		var target_position = target.global_position
		var distance = global_position.distance_to(target_position)
		if distance <= human_type.flee_range:
			$Voice.speak_dialog("fear")
			return start_action(
				Action.run,
				randf_range(0.5, 1.0),
				vector_to_direction(global_position.x - target_position.x)
				)
		
		if distance <= human_type.shoot_range:
			spawn_bullets(target_position)
			return 	start_action(
				Action.attack,
				human_type.shoot_duration,
				vector_to_direction(target_position.x - global_position.x)
			)
			
		if distance <= human_type.chase_range:
			return 	start_action(
				Action.run,
				POLL_DURATION,
				vector_to_direction(target_position.x - global_position.x)
			)
	
	# If already idle, dont disrupt the existing idle action	
	if is_idle:
		return
	
	# Idle behavior
	return start_action(
		Action.walk if randf() < human_type.wander_chance else Action.idle,
		randf_range(0.5, 3),
		randi_range(Direction.left, Direction.right) as Direction
	)

func spawn_bullets(target: Vector2):
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
	poll_timeout = POLL_DURATION
	var spritesheet = $Spritesheet
	spritesheet.flip_h = dir == Direction.left
	spritesheet.play(ANIMATIONS[act])
	
func kill() -> void:
	health = 0.0
	
	for i in range(human_type.giblet_count):
		var gib = GIBLET.instantiate()
		add_sibling(gib)
		gib.position = position
	GameState.update_threat_level(human_type.threat_value)
	
	var splatter = SPLATTER.instantiate()
	splatter.position = position
	add_sibling(splatter)
	
	queue_free()

func apply_damage(damage: float) -> bool:
	if health <= 0.0:
		return false
	if damage >= health:
		kill();
		return true
	health -= damage
	return false

func _process(delta: float) -> void:
	action_timeout -= delta
	poll_timeout -= delta
	if action_timeout < 0:
		pick_next_action()
	elif poll_timeout < 0:
		if action in [Action.idle, Action.walk]:
			pick_next_action(true)
		poll_timeout = POLL_DURATION

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
	
	if is_on_wall():
		direction = Direction.right if direction == Direction.left else Direction.left
		var spritesheet = $Spritesheet
		spritesheet.flip_h = direction == Direction.left

func _on_chat_zone_area_entered(area):
	if action == Action.idle and $ChatZone/Cooldown.is_stopped():
		if randf() < CHAT_CHANCE:
			$Voice.speak_dialog("chat")
		run_chat_timer()

func run_chat_timer():
	var duration = randf_range(CHAT_TIMEOUT_MIN, CHAT_TIMEOUT_MAX)
	$ChatZone/Cooldown.start()
