class_name HumanType
extends Resource

@export_category("Basics")
@export var name: String = "unnamed guy"
@export var max_health: float = 100.0
@export var walk_speed: float = 100.0
@export var run_speed: float = 200.0
@export var giblet_count: int = 5
@export var threat_value: int = 1
@export var wander_chance: float = 0.5
@export var sprites: SpriteFrames

@export_category("Behaviors")
@export var chase_range: float = 0.0
@export var flee_range: float = 200.0

@export_category("Ranged attacks")
@export var shoot_range: float = 0.0
@export var shoot_duration: float = 0.5
@export var bullet_damage: float = 25.0
@export var bullet_count: int = 1
@export var bullet_spread: float = 0.1 # radians

@export_category("Melee attacks (unused)")
@export var melee_range: float = 0.0
@export var melee_damage: float = 0.0
@export var melee_duration: float = 0.5
