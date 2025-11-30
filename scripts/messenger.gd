extends Node

var tree
var player
var enemies_p_wave = 5
var wave = 1
var enemies_f
var player_lifes : int = 5
var point_to_shoot
var cena_anterior : String

@warning_ignore("unused_signal")
signal dano_player
@warning_ignore("unused_signal")
signal start_selecionado
@warning_ignore("unused_signal")
signal options_selecionado
@warning_ignore("unused_signal")
signal diminuir_timer
@warning_ignore("unused_signal")
signal trocando_de_wave 

func _ready() -> void:
	tree = get_tree()
