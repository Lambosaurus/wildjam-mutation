extends Camera2D

@export var speed = 20
@export var min_zoom: float = 0.25
@export var max_zoom: float = 2.0

var is_mouse_moving_camera = false

func _process(delta):
	handle_input()

func _unhandled_input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE):
		is_mouse_moving_camera = event.is_pressed()
		
	if is_mouse_moving_camera and event is InputEventMouseMotion:
		var mouse_delta: Vector2 = event.relative
		position -= mouse_delta

func modify_zoom(scale: float):
	var pos0 = get_global_mouse_position()
	var new_zoom = zoom.x * scale
	zoom = Vector2(new_zoom, new_zoom)
	var pos1 = get_global_mouse_position()
	position -= pos1 - pos0
				
func handle_input():
	if is_mouse_moving_camera: return
	
	var move_direction = Input.get_vector("left", "right", "up", "down")
	if move_direction:
		position += move_direction * speed / zoom
	
	if Input.is_action_just_released("scroll_up"):
		if zoom.x < max_zoom:
			modify_zoom(1.1)
	elif Input.is_action_just_released("scroll_down"):
		if zoom.x > min_zoom:
			modify_zoom(1.0 / 1.1)
