extends Control

@onready var label: Label = $CanvasLayer/Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	label.visible = false
	Messenger.max_bulletas.connect(_max)

func _on_timer_timeout() -> void:
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(label, "modulate", Color("#ffffff", 0),
	 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", visibilitytyty)

func visibilitytyty():
	label.visible = false

func _max():
	label.visible = true
	timer.start()
