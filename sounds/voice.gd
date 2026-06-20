extends GameSound

@export var voice_spawn: Node2D = self
@export var duration: float = 5

@export var voice_type: VoiceType
@export var dialog_tree: DialogTree

const VoiceBubbleConstructor = preload("res://sounds/voice_bubble.tscn")

var currently_speeking = false
var current_voice_bubble: VoiceBubble

func speak_dialog(key: String, force = false):
	if currently_speeking and not force: return
	var speech = dialog_tree.get_any_speech(key)
	if not speech: return
	
	if speech.clip: play_clip(speech.clip)
	if speech.dialog: show_spoken_dialog(speech.dialog)
	
func show_spoken_dialog(dialog: String):
	if not voice_spawn: return
	
	if current_voice_bubble: current_voice_bubble.queue_free()
	
	current_voice_bubble = VoiceBubbleConstructor.instantiate() as VoiceBubble
	current_voice_bubble.dialog = dialog
	current_voice_bubble.duration = duration
	current_voice_bubble.color = voice_type.color
	voice_spawn.add_child(current_voice_bubble)
	
func play_clip(clip: AudioStream):
	pitch_scale = voice_type.pitch
	stream = clip
	play()
