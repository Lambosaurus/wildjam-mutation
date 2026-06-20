extends Area2D

@export var damage: float = 20.0
@export var speed: float = 600.0
@export var velocity: Vector2:
	set(value):
		$Sprite.rotation = value.angle()
		velocity = value

const POP = preload("res://entities/pop/pop.tscn")

@onready var sounds = $Sounds

func _ready():
	sounds.play()

func set_target(target: Vector2, spread: float = 0.0) -> void:
	var angle = (target - global_position).angle()
	angle += randf_range(-spread, +spread)
	velocity = Vector2.from_angle(angle) * speed
	
func _on_body_entered(body: Node2D) -> void:
	if "apply_damage" in body:
		body.apply_damage(damage)
		
	var pop = POP.instantiate()
	pop.position = position
	pop.modulate = Color("FFB000")
	pop.scale *= 0.4
	add_sibling(pop)
		
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta
