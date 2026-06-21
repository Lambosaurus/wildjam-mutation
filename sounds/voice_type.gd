class_name VoiceType
extends Resource

@export_group("Voice")
@export var pitch: float
@export var color: Color = Color.YELLOW

func get_pitch():
	return pitch
