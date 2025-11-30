extends Node2D

@onready var start: Button = $"../Start"
@onready var options: Button = $"../Options"
@onready var resume: Button = $"../Resume"
@onready var exit: Button = $"../Exit"

func _ready() -> void:
	Messenger.start_selecionado.connect(start_selecionado)
	Messenger.options_selecionado.connect(options_selecionado)
	Messenger.resume_selecionado.connect(resume_selecionado)

func start_selecionado():
	if start:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", start.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func options_selecionado():
	if options:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", options.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func resume_selecionado():
	if resume:
		var tween := get_tree().create_tween()
		tween.tween_property(self, "global_position", resume.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.set_unscaled(true)
		

func exit_selecionado():
	if exit:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", exit.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
