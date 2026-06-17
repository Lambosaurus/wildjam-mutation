extends Control

var game_scene: PackedScene = preload("res://main/main.tscn")

@onready var help_screen = $HelpScreen

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(game_scene)

func _on_how_to_play_button_pressed():
	toggle_help_screen()

func _on_exit_button_pressed():
	get_tree().quit()

func toggle_help_screen():
	help_screen.visible = !help_screen.visible

func _on_back_button_pressed():
	toggle_help_screen()
