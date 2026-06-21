class_name MutationType
extends Resource

@export var speed_bonus: float = 1.0
@export var damage_bonus: float = 1.0
@export var attack_rate_bonus: float = 1.0
@export var health_bonus: float = 1.0

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
