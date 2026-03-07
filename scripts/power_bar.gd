extends Control

@onready var progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var light: PointLight2D = $PointLight2D
@onready var animation: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var particles: CPUParticles2D = $CanvasLayer/CPUParticles2D
@onready var particles2: CPUParticles2D = $CanvasLayer/CPUParticles2D2

func _ready() -> void:
	particles.emitting = false
	particles2.emitting = false

func _process(_delta: float) -> void:
	var pos_y = map_value(progress_bar.value)
	particles.position = Vector2(11.0, pos_y)
	particles2.position = Vector2(11.0, pos_y)
	
	if Input.is_action_pressed("charge") and not Messenger.paused :
		particles.emitting = true
		particles2.emitting = true
		progress_bar.value = progress_bar.value + progress_bar.step
	
	else:
		particles.emitting = false
		particles2.emitting = false
	
	if progress_bar.value >= 92:
		particles.emitting = false
		particles2.emitting = false
		animation.play("bar_cheia")
		animation.animation_finished.connect(_process)
	
	else:
		animation.play("parado")
		animation.animation_finished.connect(_process)
	
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power1"):
		if not Messenger.paused:
			progress_bar.value = 0
			Messenger.powerasso.emit()

func map_value(value):
	var min1 = 14.0
	var max1 = 92.0
	var min2 = 108.0
	var max2 = 82.0
	
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1)
