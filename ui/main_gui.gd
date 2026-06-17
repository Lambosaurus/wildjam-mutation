extends Control

@export var mutation_service: MutationService

func _ready():
	SelectionManager.connect("node_selected", add_selected)
	SelectionManager.connect("node_deselected", remove_selected)
	$ErrorLabel/UITimer.connect("timeout", clear_error)
	
	add_mutations_to_list()

func _process(_delta):
	update_biomass()
	update_selection()
	
func add_mutations_to_list():
	var mutations = mutation_service.available_mutations
	for mutation in mutations:
		var label = "{name} #:{cost}".format(mutation)
		$SelectPanel/SelectionContainer/Mutations.add_item(label, null, true)
	
func update_biomass():
	$BioMass/Amount.text = str(GameState.biomass)

func remove_selected(node: SelectionArea):
	if node.action_target is Mutant:
		$SelectPanel/SelectionContainer/SelectedCreatures.remove_item(0)

func add_selected(node: SelectionArea):
	if node.action_target is Mutant:
		$SelectPanel/SelectionContainer/SelectedCreatures.add_item("M", null, false)

func update_selection():
	$SelectPanel.visible = !SelectionManager.selected_nodes_dict.is_empty()
	#if $SelectPanel/SelectionContainer.visible:
		#$SelectPanel/SelectionContainer/SelectedCreatures.clear()
		#var items = SelectionManager.get_selected_nodes()
		#for mutant in items:
			#$SelectPanel/SelectionContainer/SelectedCreatures.add_item("Mutant")

func clear_error():
	$ErrorLabel.visible = true
	$ErrorLabel.text = ""

func display_error(message: String, timeout: float = 1):
	$ErrorLabel.visible = true
	$ErrorLabel.text = message
	$ErrorLabel/UITimer.start(timeout)

func _on_mutations_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var mutation = mutation_service.available_mutations[index]
	if not mutation: return
	
	for creature in SelectionManager.get_selected_nodes():
		if creature.action_target is Mutant:
			if not mutation_service.apply_mutation_to(mutation, creature.action_target):
				display_error("Not enough Biomass")
				
				
