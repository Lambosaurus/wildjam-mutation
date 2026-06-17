extends Node

@export var sound_level = -10.0
@export var music_level = -10.0

signal setting_changed(setting: String, value: Variant)

func set_setting(setting: String, value: Variant):
	set(setting, value)
	setting_changed.emit(setting, value)
