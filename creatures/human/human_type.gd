class_name HumanType
extends Resource

@export var max_health: float = 100.0
@export var walk_speed: float = 100.0

@export var chase_range: float = 0.0
@export var flee_range: float = 200.0
@export var run_speed: float = 200.0

@export var attack_range: float = 500.0
@export var bullet_damage: float = 25.0
@export var bullet_count: int = 1
@export var bullet_spread: float = 0.1 # radians
@export var attack_duration: float = 0.5

func spawn_attacks(target: Vector2) -> void:
	pass
