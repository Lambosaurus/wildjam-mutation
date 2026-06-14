extends GridContainer

var items

func _process(delta):
	items = SelectionManager.get_selected_nodes()	
