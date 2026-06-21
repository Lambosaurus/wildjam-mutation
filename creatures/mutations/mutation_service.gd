class_name MutationService
extends Resource

@export var available_mutations: Array[Mutation] = []

func get_random_mutation():
	return available_mutations.pick_random()
	
func apply_mutation_to(mutation: Mutation, mutant: Mutant):
	if mutant.has_mutation(mutation): return "Mutation already applied"
	
	if mutation.cost <= GameState.biomass:
		GameState.biomass -= mutation.cost
		mutant.mutate(mutation)
		return true
	else: return "Not enough Biomass"
	
