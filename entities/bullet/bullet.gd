extends Area2D

@export var damage: float = 20.0
@export var speed: float = 300.0
@export var velocity: Vector2

func set_target(target: Vector2) -> void:
	var delta: Vector2 = target - global_position
	var length = delta.length()
	if length < 0.1:
		# handle fuckups
		delta = Vector2(1.0,0)
		length = 1.0
	velocity = delta * speed / length

func _on_body_entered(body: Node2D) -> void:
	if "apply_damage" in body:
		body.apply_damage(damage)
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta
