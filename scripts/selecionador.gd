extends Node2D

@onready var start: Button = $"../Start"
@onready var options: Button = $"../Options"
@onready var quit: Button = $"../Quit"



func _ready() -> void:
	Messenger.start_selecionado.connect(button_selection.bind(start))
	Messenger.options_selecionado.connect(button_selection.bind(options))
	Messenger.quit_selecionado.connect(button_selection.bind(quit))


func button_selection(button_selected):
	if button_selected:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", button_selected.global_position,
		 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
