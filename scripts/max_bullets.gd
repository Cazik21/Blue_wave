extends Control

@onready var label: Label = $CanvasLayer/Label
@onready var timer: Timer = $Timer

var tweenop

func _ready() -> void:
	label.visible = false
	Messenger.max_bulletas.connect(_max)

func _on_timer_timeout() -> void:
	tweenop = get_tree().create_tween()
	tweenop.tween_property(label, "modulate", Color("#ffffff", 0),
	 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", _ready)

func _max():
	label.modulate = Color("ffffff", 100)
	label.visible = true
	timer.start()
	
