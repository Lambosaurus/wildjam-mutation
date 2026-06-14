class_name MutationService
extends Resource

@export var available_mutations: Array[Mutation] = []

func get_random_mutation():
	return available_mutations.pick_random()
