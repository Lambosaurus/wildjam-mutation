extends Control

var main_menu = preload("res://ui/start_screen.tscn")

func _ready():
	get_tree().paused = true
	
func resume():
	get_tree().paused = false
	queue_free()

func _on_resume_button_pressed():
	resume()

func _on_quit_button_pressed():
	get_tree().change_scene_to_packed(main_menu)
	
func _on_exit_button_pressed():
	get_tree().quit()


func _on_gui_input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_ESCAPE):
		resume()
		
