extends Node

const MAX_THREAT = 100

var biomass: int = 1000
var threat_level: int = 0
enum GameState {Play, BossPhase, Win, Loss} 
var current_state = GameState.Play

var main_menu = preload("res://ui/start_screen.tscn")

func update_threat_level(amount: int):
	threat_level += amount
	print('threat level ', threat_level)
	update_game_state()
	
func update_game_state():
	if threat_level >= 100:
		current_state = GameState.BossPhase
		print("Boss Phase")

func reset_game_state():
	biomass = 1000
	threat_level = 0
	current_state = null

func quit():
	reset_game_state()
	get_tree().change_scene_to_packed(main_menu)
# add threat
# takes in an amount
# if threatlevel > level
