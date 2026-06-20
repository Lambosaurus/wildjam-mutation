extends Area2D

@export var damage: float = 0.0
@onready var sounds = $Sounds
@export var flip_h: bool:
	set(value):
		flip_h = value
		$Animation.flip_h = value

func _ready():
	sounds.play()
	$Animation.play()

func _process(delta: float) -> void:
	if damage > 0:
		for node:Node2D in get_overlapping_bodies():
			if "apply_damage" in node:
				node.apply_damage(damage)
				damage = 0
				break

func _on_animation_animation_finished() -> void:
	queue_free()
