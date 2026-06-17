extends Control

@onready var music_slider = $HBoxContainer/MusicBox/MusicSlider as VSlider
@onready var sound_slider = $HBoxContainer/SoundBox/SoundsSlider as VSlider

func _ready():
	music_slider.value = Settings.music_level
	sound_slider.value = Settings.sound_level

func _on_music_slider_drag_ended(value_changed):
	Settings.set_setting("music_level", music_slider.value)


func _on_sounds_slider_drag_ended(value_changed):
	Settings.set_setting("sound_level", sound_slider.value)
