extends Node2D

@onready var resume: Button = $"../Resume"
@onready var options: Button = $"../options"
@onready var exit: Button = $"../Exit"


func _ready() -> void:
	Messenger.resume_selecionado.connect(button_selection.bind(resume))
	Messenger.options_selecionado.connect(button_selection.bind(options))
	Messenger.exit_selecionado.connect(button_selection.bind(exit))


func button_selection(button_selected):
	if button_selected:
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(self, "global_position", button_selected.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
