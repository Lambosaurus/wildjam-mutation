class_name MutationType
extends Resource

@export var speed_bonus: float = 0.0
@export var damage_bonus: float = 0.0
@export var attack_rate_bonus: float = 0.0

func apply(mut: MutantType) -> void:
	if speed_bonus:
		mut.run_speed *= speed_bonus
		mut.walk_speed *= speed_bonus
	if damage_bonus:
		mut.attack_damage *= damage_bonus
	if attack_rate_bonus:
		mut.attack_duration /= attack_rate_bonus
