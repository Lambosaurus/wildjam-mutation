extends Node

signal node_selected(node: Node)
signal node_deselected(node: Node)

var selected_nodes_dict = {}

func select_node(node):
	selected_nodes_dict[node] = true
	node_selected.emit(node)
	
func deselect_node(node):
	selected_nodes_dict.erase(node)
	node_deselected.emit(node)

func get_selected_nodes():
	return selected_nodes_dict.keys()
