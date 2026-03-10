extends Node

var can_spawn_enemy
var tree
var player
var enemies_p_wave = 3
var wave = 1
var enemies_f
var player_lifes : int = 5
var point_to_shoot
var killed_enemies = 0
var org_color_for_enemy
var type_of_the_bullet : String
var cena_anterior : String
var paused : bool = false
var balas_q_tenho : Array = [32, 0, 0, 0, 0]
var scroll_pos = 0
var master_volume = 100.0
var sounds_volume = 100.0
var music_volume = 100.0

@warning_ignore("unused_signal")
signal spawn_grounded_enemy
@warning_ignore("unused_signal")
signal dano_player
@warning_ignore("unused_signal")
signal start_selecionado
@warning_ignore("unused_signal")
signal options_selecionado
@warning_ignore("unused_signal")
signal quit_selecionado
@warning_ignore("unused_signal")
signal diminuir_timer
@warning_ignore("unused_signal")
signal trocando_de_wave 
@warning_ignore("unused_signal")
signal resume
@warning_ignore("unused_signal")
signal resume_selecionado
@warning_ignore("unused_signal")
signal exit_selecionado
@warning_ignore("unused_signal")
signal voltou_pro_game_brabo
@warning_ignore("unused_signal")
signal saiu_pq_meno
@warning_ignore("unused_signal")
signal max_bulletas
@warning_ignore("unused_signal")
signal powerasso

func _ready() -> void:
	tree = get_tree()
