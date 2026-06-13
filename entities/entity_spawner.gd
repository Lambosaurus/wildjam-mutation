extends StaticBody2D

signal spawn_on_position(position, type)
var enemy_scene = preload('res://creatures/human/human.tscn')
@onready var main_node = get_parent().get_parent()


func _input_event(viewport: Viewport, event: InputEvent, shape_id: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print('spawning human at ', global_position)
			var enemy = enemy_scene.instantiate()
			main_node.add_child(enemy)
			enemy.global_position = get_global_mouse_position()
			spawn_on_position.emit(global_position, "human")
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print('spawning friendly at ', global_position)
