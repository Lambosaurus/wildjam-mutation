extends Node

const MAX_THREAT = 100

var biomass: int = 1000
var threat_level: int = 0
enum GameState {Play, Win, Loss} 
var current_state = GameState.Play

var main_menu = preload("res://ui/start_screen.tscn")

const HUMAN_BASE = preload("res://creatures/human/human.tscn")
const HUMAN_GUARD = preload("res://creatures/human/types/security_guard.tres")
const HUMAN_OFFICER = preload("res://creatures/human/types/security_guard.tres")
const HUMAN_ENFORCER = preload("res://creatures/human/types/security_enforcer.tres")
const HUMAN_DEFENDER = preload("res://creatures/human/types/swat_defender.tres")
const HUMAN_OFFENDER = preload("res://creatures/human/types/swat_offender.tres")

const THREAT_THRESHOLDS: Dictionary = {
	25: [ HUMAN_OFFICER, HUMAN_GUARD ],
	50: [ HUMAN_OFFICER, HUMAN_ENFORCER, HUMAN_ENFORCER],
	75: [ HUMAN_OFFICER, HUMAN_DEFENDER, HUMAN_DEFENDER ],
	100: [ HUMAN_DEFENDER, HUMAN_DEFENDER, HUMAN_DEFENDER, HUMAN_DEFENDER, HUMAN_OFFENDER, HUMAN_OFFENDER, HUMAN_OFFENDER, HUMAN_OFFENDER ],
}

var threat_thresholds: Dictionary = THREAT_THRESHOLDS.duplicate()

func get_main_node() -> Node2D:
	return get_node("/root/Main")

func update_threat_level(amount: int):
	threat_level = int(move_toward(threat_level, MAX_THREAT, amount))
	
	# Now consider our threat levels
	for key in threat_thresholds.keys():
		if threat_level >= key:
			var root = get_main_node()
			var units = threat_thresholds[key]
			threat_thresholds.erase(key)
			for human_type: HumanType in units:
				var human = HUMAN_BASE.instantiate()
				human.human_type = human_type
				human.position = root.swat_spawn_point.position
				root.add_child(human)
				print("Spawning human: ", human_type.name)

func reset_game_state():
	biomass = 1000
	threat_level = 0
	threat_thresholds = THREAT_THRESHOLDS.duplicate()

func quit():
	reset_game_state()
	get_tree().change_scene_to_packed(main_menu)
