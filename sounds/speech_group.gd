class_name SpeechGroup
extends Resource

@export var speeches: Array[Speech]

var _last_played = -1

func get_random_speech() -> Speech:
	return speeches.pick_random()

func get_next_speech():
	if _last_played >= len(speeches): _last_played = -1
	_last_played += 1
	return speeches[_last_played]
	
