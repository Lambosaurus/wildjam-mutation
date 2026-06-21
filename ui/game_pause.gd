extends Control

@onready var _tree = get_tree()

@export var paused = false:
	set(value):
		visible = value
		_tree.paused = value
	get():
		return _tree.paused

func _input(event):
	if (event is InputEventKey and event.keycode == KEY_SPACE and not event.is_echo() and event.is_pressed()):
		paused = not paused
