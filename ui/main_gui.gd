extends Control

func _process(delta):
	update_biomass()
	
func update_biomass():
	$BioMass/Amount.text = str(GameState.biomass)
