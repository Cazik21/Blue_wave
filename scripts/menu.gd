extends CanvasLayer

@onready var iluminação: PointLight2D = $iluminação

func _ready() -> void:
	Messenger.cena_anterior = "res://scenes/tela_inicial.tscn"
	iluminação.energy = 0.8
