extends Node2D

signal spawn_on_position(position, type)

@export var spawn_location: Node2D
@export var spawnable: PackedScene

func _on_static_body_2d_input_event(viewport: Viewport, event: InputEvent, shape_id: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var enemy = spawnable.instantiate()
			spawn_location.add_child(enemy)		
			
			spawn_on_position.emit(global_position, "human")
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print('spawning friendly at ', global_position)
