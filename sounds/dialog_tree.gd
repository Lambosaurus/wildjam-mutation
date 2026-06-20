class_name DialogTree
extends Resource

@export var dialogs: Dictionary[String, SpeechGroup]

func get_any_speech(key: String):
	if not dialogs[key]: return null
	
	return dialogs[key].get_random_speech()

func get_dialog_keys():
	dialogs.keys()
