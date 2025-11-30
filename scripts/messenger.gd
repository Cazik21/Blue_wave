extends Node

var can_spawn_enemy
var tree
var player
var enemies_p_wave = 5
var wave = 1
var enemies_f
var player_lifes : int = 5
var point_to_shoot
<<<<<<< HEAD
var killed_enemies = 0
var org_color_for_enemy

=======
var org_color_for_enemy
>>>>>>> ec2294d73781cf1eea27e9eac78e53c2e93f252a
var cena_anterior : String

var paused : bool

@warning_ignore("unused_signal")
signal spawn_grounded_enemy
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
@warning_ignore("unused_signal")
signal resume
@warning_ignore("unused_signal")
signal resume_selecionado
@warning_ignore("unused_signal")
signal exit_selecionado

func _ready() -> void:
	tree = get_tree()
