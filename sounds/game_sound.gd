class_name GameSound
extends AudioStreamPlayer2D

func _ready():
	update_volume("sound_level", Settings.sound_level)
	Settings.setting_changed.connect(update_volume)

func update_volume(setting: String, value: float):
	if setting != "sound_level": return
	
	volume_db = value
