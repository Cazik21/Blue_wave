extends Node2D

@onready var resume: Button = $"../Resume"

@onready var options: Button = $"../options"

@onready var exit: Button = $"../Exit"


func _ready() -> void:
	Messenger.resume_selecionado.connect(resume_selecionado)
	Messenger.options_selecionado.connect(options_selecionado)
	Messenger.exit_selecionado.connect(exit_selecionado)

func resume_selecionado():
	if resume:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", resume.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func options_selecionado():
	if options:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", options.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func exit_selecionado():
	if exit:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", exit.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
