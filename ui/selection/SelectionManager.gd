extends Node

signal node_selected(node: SelectionArea)
signal node_deselected(node: SelectionArea)

var selected_nodes_dict = {}

func clicked_node(node, button):
	if (is_selected(node)):
		if (button == MOUSE_BUTTON_RIGHT):
			deselect_node(node)
	else:
		if (button == MOUSE_BUTTON_LEFT):
			select_node(node)
	
func is_selected(node):
	return selected_nodes_dict.has(node)

func select_node(node: SelectionArea):
	var shader_material = node.highlight_shader
	selected_nodes_dict[node] = true
	if shader_material:
		node.get_selectable_node().material = shader_material
	node_selected.emit(node)
	
func deselect_node(node: SelectionArea):
	selected_nodes_dict.erase(node)
	node.get_selectable_node().material = null
	node_deselected.emit(node)

func get_selected_nodes():
	return selected_nodes_dict.keys()
	
func deselect_all():
	for node in selected_nodes_dict.keys():
		deselect_node(node)
