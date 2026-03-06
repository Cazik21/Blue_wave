extends Control

@onready var progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var light: PointLight2D = $PointLight2D
@onready var animation: AnimationPlayer = $CanvasLayer/AnimationPlayer


var tween2_fin : bool = true

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_pressed("charge") and not Messenger.paused :
		await get_tree().create_timer(0.4).timeout
		progress_bar.value = progress_bar.value + progress_bar.step
	
	if progress_bar.value >= 92:
		animation.play("bar_cheia")
		animation.animation_finished.connect(_process)
	
	else:
		animation.play("parado")
		animation.animation_finished.connect(_process)
	
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power1"):
		progress_bar.value = 0
		Messenger.powerasso.emit()
