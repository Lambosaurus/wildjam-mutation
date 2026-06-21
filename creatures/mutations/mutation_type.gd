class_name MutationType
extends Resource

@export var speed_bonus: float = 1.0
@export var damage_bonus: float = 1.0
@export var attack_rate_bonus: float = 1.0
@export var health_bonus: float = 1.0
@export var chase_range_bonus: float = 1.0
@export var eat_range_bonus: float = 1.0
@export var eat_efficiency_bonus: float = 1.0
@export var swarm_attractor_bonus: float = 0
@export var swarm_bonus: float = 1.0
@export var elevator_bonus: float = 1.0
@export var spawn_on_kill: int = 0
@export var spawn_on_timeout: int = 0

func apply(mut: MutantType) -> void:
	# Speed
		mut.run_speed *= speed_bonus
		mut.walk_speed *= speed_bonus
	# Damage
		mut.attack_damage *= damage_bonus
	# Attack
		mut.attack_duration /= attack_rate_bonus
	# Health
		mut.max_health *= health_bonus
	# Chase range
		mut.chase_range *= chase_range_bonus
	# Eating
		mut.eat_range *= eat_range_bonus
		mut.eat_efficiency *= eat_efficiency_bonus
	# Elevators
		mut.elevator_attraction *= elevator_bonus
		mut.elevator_range *= elevator_bonus
	# Spawning
		mut.spawn_on_kill += spawn_on_kill
		mut.spawn_on_timeout += spawn_on_timeout
	# Swarming
		mut.swarm_attraction *= swarm_bonus
		mut.swarm_leader += swarm_attractor_bonus
