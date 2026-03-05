extends Control

@onready var progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var light: PointLight2D = $PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = 9.0
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("charge"):
		await get_tree().create_timer(0.4).timeout
		progress_bar.value = progress_bar.value + progress_bar.step
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power1"):
		progress_bar.value = 0
		Messenger.powerasso.emit()
