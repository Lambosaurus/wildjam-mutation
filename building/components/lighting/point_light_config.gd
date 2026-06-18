extends PointLight2D

@export var blink: bool = false
enum BlinkFrequency { Low, Medium, High }
@export var blink_frequency: BlinkFrequency
@onready var blink_timer: Timer = $Timer
var energy_target = self.energy
var rng = RandomNumberGenerator.new()
var blink_rate: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (blink):
		print('blink active')
		blink_timer.connect("timeout", _on_blink_timeout)
		calc_energy_target()
	pass # Replace with function body.

func calc_blink_intensity():
	match blink_frequency:
		BlinkFrequency.Low:
			return {"lower": 0.1, "upper": 0.3}
		BlinkFrequency.Medium:
			return {"lower": 0.05, "upper": 0.15}
		BlinkFrequency.High:
			return {"lower": 0.01, "upper": 0.02}
	
	
func calc_energy_target():
	var light_tween = create_tween()
	energy_target = rng.randi_range(0.0, 1.0)
	light_tween.tween_property(self, "energy", energy_target, 0.05)
	
	var freq_range = calc_blink_intensity()
	blink_timer.start(rng.randf_range(freq_range.lower, freq_range.upper))

func _on_blink_timeout():
	calc_energy_target()
	
