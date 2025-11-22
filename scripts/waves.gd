extends Control

@onready var label: Label = $waves/text
@onready var label2: Label = $lifes/text

func _ready() -> void:
	waves()

func _process(_delta: float) -> void:
	if Messenger.enemies_f <= 0:
		Messenger.wave += 1
		Messenger.enemies_p_wave += 5
		waves()

func waves():
	Messenger.enemies_f = Messenger.enemies_p_wave
	label.text = ("wave " + str(Messenger.wave))
	Messenger.diminuir_timer.emit()
