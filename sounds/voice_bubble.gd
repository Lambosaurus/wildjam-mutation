class_name VoiceBubble
extends Control

@export var dialog: String:
	set(value):
		_text_buffer = value
		$DialogContainer/Dialog.text = ""
@export var color: Color:
	set(value):
		$DialogContainer/Dialog.label_settings.font_color = value
		
@export var duration: float
@export var speed: float = 10: # Characters per second
	set(value):
		_speed_in_ms = value / 1000

@onready var stop_timer = $StopTimer
@onready var write_timer = $WriteTimer

var _speed_in_ms: float = 0.001
var _text_buffer: String

signal text_complete
signal speech_complete

func _ready():
	write_timer.start(_speed_in_ms)

func _on_text_complete():
	stop_timer.start(duration)

func _on_stop_timer_timeout():
	speech_complete.emit()
	queue_free() # Replace with function body.

func _on_write_timer_timeout():
	if len(_text_buffer):
		var character = _text_buffer[0]
		$DialogContainer/Dialog.text += character
		_text_buffer = _text_buffer.erase(0)
	
	if len(_text_buffer) <= 0:
		text_complete.emit()
		write_timer.stop()
