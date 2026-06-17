class_name GameMusic
extends AudioStreamPlayer

func _ready():
	update_volume("music_level", Settings.music_level)
	Settings.setting_changed.connect(update_volume)

func update_volume(setting: String, value: float):
	if setting != "music_level": return
	
	volume_db = value
