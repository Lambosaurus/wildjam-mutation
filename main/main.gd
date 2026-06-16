extends Node2D

@export var mutation_service: MutationService
@export_group("Camera")
@export var camera_speed = 20

func _ready():
	$GUILayer/MainGUI.mutation_service = mutation_service

func _process(delta):
	if (Input.is_action_pressed("swap_arms")):
		var mutation = mutation_service.get_random_mutation()
		for selected in SelectionManager.get_selected_nodes():
			if not is_instance_valid(selected):
				continue
			var action_target = selected.action_target
			if action_target is Mutant:
				action_target.mutate(mutation)
	update_camera()
				
func update_camera():
	var move_direction = Input.get_vector("left", "right", "up", "down")
	if move_direction:
		$MainCamera.position += move_direction * camera_speed
	
