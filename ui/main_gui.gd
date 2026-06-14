extends Control

func _ready():
	SelectionManager.connect("node_selected", add_selected)
	SelectionManager.connect("node_deselected", remove_selected)

func _process(delta):
	update_biomass()
	update_selection()
	
func update_biomass():
	$BioMass/Amount.text = str(GameState.biomass)

func remove_selected(node: SelectionArea):
	if node.action_target is Mutant:
		$SelectPanel/SelectionContainer/ItemList.remove_item(0)

func add_selected(node: SelectionArea):
	if node.action_target is Mutant:
		$SelectPanel/SelectionContainer/ItemList.add_item("M", null, false)

func update_selection():
	$SelectPanel.visible = !SelectionManager.selected_nodes_dict.is_empty()
	#if $SelectPanel/SelectionContainer.visible:
		#$SelectPanel/SelectionContainer/ItemList.clear()
		#var items = SelectionManager.get_selected_nodes()
		#for mutant in items:
			#$SelectPanel/SelectionContainer/ItemList.add_item("Mutant")
