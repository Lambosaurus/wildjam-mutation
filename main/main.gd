extends Node2D

@export var mutation_service: MutationService
@export_group("Camera")
@export var camera_speed = 20

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
		$MainCamera.position += move_direction * camera_speed
	
