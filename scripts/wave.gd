extends Node2D

@onready var shake_icon = $ShakeIcon # Supondo que você tem um nó Sprite2D chamado "ShakeIcon" na sua cena


var shake_amount = 5
var shake_duration = 3
var tween: Tween

func _ready():
	# Exemplo: iniciar o shake quando a cena carregar
	start_shake()

func start_shake():
	await get_tree().create_timer(randi_range(0, 3)).timeout
	# Garante que apenas um tween esteja ativo por vez
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_loops() # Para que o shake continue até ser interrompido (ou você pode usar tween.set_ease() e tween.set_trans() para um único movimento)

	# Inicia o tween em torno da posição original
	var original_pos = global_position
	
	# Move para a esquerda
	tween.tween_property(self, "global_position", original_pos - Vector2(shake_amount, 0), shake_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# Move para a direita
	tween.tween_property(self, "global_position", original_pos + Vector2(shake_amount, 0), shake_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# Retorna à posição original

func get_original_position():
	# Você pode armazenar a posição original em _ready()
	return Vector2(0,0) # Substitua pelo seu método de pegar a posição original
