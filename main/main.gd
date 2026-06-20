extends Node2D

@export var mutation_service: MutationService
@export_group("Camera")
@export var camera_speed = 20
@export var threat_level = 0
@export var min_zoom: float = 0.25
@export var max_zoom: float = 2.0

@export var zoom = 1.0:
	set(value):
		zoom = value
		$MainCamera.zoom = Vector2(zoom, zoom)

var pause_menu = preload("res://ui/pause_menu.tscn")

func _ready():
	$GUILayer/MainGUI.mutation_service = mutation_service

func _process(delta):
	if (Input.is_key_pressed(KEY_ESCAPE)):
		$GUILayer.add_child(pause_menu.instantiate())
	
	update_camera()
				
func update_camera():
	var move_direction = Input.get_vector("left", "right", "up", "down")
	if move_direction:
		$MainCamera.position += move_direction * camera_speed / zoom
	
	if Input.is_action_just_released("scroll_up"):
		if zoom < max_zoom:
			zoom *= 1.1
	elif Input.is_action_just_released("scroll_down"):
		if zoom > min_zoom:
			zoom /= 1.1
