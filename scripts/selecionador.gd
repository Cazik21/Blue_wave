extends Node2D

@onready var start: Button = $"../Start"
@onready var options: Button = $"../Options"

func _ready() -> void:
	Messenger.start_selecionado.connect(start_selecionado)
	Messenger.options_selecionado.connect(options_selecionado)

func start_selecionado():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", start.global_position,
	 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func options_selecionado():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", options.global_position,
	 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
