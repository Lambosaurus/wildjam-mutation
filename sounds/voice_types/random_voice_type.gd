class_name RandomVoiceType
extends VoiceType

@export_group("Random")
@export_range(0.1, 2.0) var pitch_min: float = 0.85
@export_range(0.1, 2.0) var pitch_max: float = 1.3

func get_pitch():
	return randf_range(pitch_min, pitch_max)
