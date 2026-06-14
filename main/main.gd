extends Node2D

@export var mutation_service: MutationService

func _process(delta):
	if (Input.is_action_pressed("swap_arms")):
		var mutation = mutation_service.get_random_mutation()
		for selected in SelectionManager.get_selected_nodes():
			var action_target = selected.action_target
			if action_target is Mutant:
				action_target.mutate(mutation)
