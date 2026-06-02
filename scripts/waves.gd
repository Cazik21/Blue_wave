extends Control

@onready var label: Label = $waves/text

func _ready() -> void:
	get_tree().create_tween().tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0)
	waves()

func _process(_delta: float) -> void:
	if Messenger.in_combat:
		get_tree().create_tween().tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 3)
	else:
		label.text = "Completed"
		get_tree().create_tween().tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 3)
	if Messenger.enemies_f <= 0:
		Messenger.wave += 1
		Messenger.enemies_p_wave += 3
		waves()

func waves():
	Messenger.enemies_f = Messenger.enemies_p_wave
	label.text = ("wave " + str(Messenger.wave))
	Messenger.diminuir_timer.emit()
	
	
