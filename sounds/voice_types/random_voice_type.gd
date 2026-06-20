class_name RandomVoiceType
extends VoiceType

@export_group("Random")
@export_range(0, 5) var pitch_range: float = 2
@export_range(0, 5) var cadence_range: float = 2

func _ready():
	pitch = randf() * pitch_range
	cadence = randf() * cadence_range
