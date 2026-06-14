extends Node

signal node_selected(node: SelectionArea)
signal node_deselected(node: SelectionArea)

var _current_group = null
var selected_nodes_dict: Dictionary[SelectionArea, bool] = {}

func clicked_node(node, button):
	if node.group != _current_group: 
		deselect_all()
		_current_group = node.group
	if (is_selected(node)):
		if (button == MOUSE_BUTTON_RIGHT):
			deselect_node(node)
	else:
		if (button == MOUSE_BUTTON_LEFT):
			select_node(node)
	
func is_selected(node):
	return selected_nodes_dict.has(node)
	
func any_selected():
	return not selected_nodes_dict.is_empty()

func select_node(node: SelectionArea):
	selected_nodes_dict[node] = true
	if node.get_selectable_node():
		node.highlight(true)
	node_selected.emit(node)
	
func deselect_node(node: SelectionArea):
	selected_nodes_dict.erase(node)
	if node.get_selectable_node():
		node.highlight(false)
	node_deselected.emit(node)
	if not any_selected():  _current_group = null

func get_selected_nodes():
	return selected_nodes_dict.keys()
	
func deselect_all():
	for node in selected_nodes_dict.keys():
		deselect_node(node)
