extends Node2D

@export var mutation_service: MutationService

@export var swat_spawn_point: Node2D

var pause_menu = preload("res://ui/pause_menu.tscn")

const DESELECT_BUTTONS = [MOUSE_BUTTON_RIGHT]

func _ready():
	$GUILayer/MainGUI.mutation_service = mutation_service

func _process(_delta):
	if (Input.is_key_pressed(KEY_ESCAPE)):
		$GUILayer.add_child(pause_menu.instantiate())

func _unhandled_input(event):
	if (event is InputEventMouseButton and DESELECT_BUTTONS.has(event.button_index) and event.is_pressed()):
		SelectionManager.deselect_all()
