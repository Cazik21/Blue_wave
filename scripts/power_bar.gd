extends Control

#region @onready's
@onready var progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var animation: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var particles: CPUParticles2D = $CanvasLayer/ChargeParticles
@onready var particles2: CPUParticles2D = $CanvasLayer/ChargeParticles2
@onready var timer: Timer = $Timer
@onready var decresing_particles: CPUParticles2D = $CanvasLayer/DecresingParticles
#endregion

func _ready() -> void:
	Messenger.powerasso.connect(animationzinha_descendo_a_barra.bind(9.0))
	Messenger.escudozasso.connect(animationzinha_descendo_a_barra.bind(64))
	decresing_particles.emitting = false
	particles.emitting = false
	particles2.emitting = false

func _process(_delta: float) -> void:
	var pos_y = map_value(progress_bar.value)
	decresing_particles.position.y = pos_y
	particles.position.y = pos_y
	particles2.position.y = pos_y
	
	if Input.is_action_just_pressed("charge"):
		timer.start()

	if not (Input.is_action_pressed("charge")):
		timer.stop()
		particles.emitting = false
		particles2.emitting = false
	
	
	if progress_bar.value >= 92:
		particles.emitting = false
		particles2.emitting = false
		animation.play("bar_cheia")
	
	else:
		animation.play("parado")

	
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power1"):
		Messenger.powerasso.emit()
	
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power2"):
		Messenger.escudozasso.emit()



func map_value(value):
	var min1 = 14.0
	var max1 = 92.0
	var min2 = 108.0
	var max2 = 82.0
	
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1)

func _on_timer_timeout() -> void:
	
	while Input.is_action_pressed("charge"):
		await get_tree().create_timer(get_process_delta_time()).timeout
		particles.emitting = true
		particles2.emitting = true
		progress_bar.value += progress_bar.step


func animationzinha_descendo_a_barra(balor):
	decresing_particles.emitting = true
	while progress_bar.value > balor:
		await get_tree().create_timer(get_process_delta_time()).timeout
		progress_bar.value -= 5
	decresing_particles.emitting = false
