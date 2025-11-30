extends CanvasLayer

@onready var iluminação: PointLight2D = $iluminação

func _ready() -> void:
	Messenger.cena_anterior = "res://scenes/tela_inicial.tscn"
	if OS.get_name() == "macOS":
		iluminação.energy = 2.2
	else:
		iluminação.energy = 0.8
