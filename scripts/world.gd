extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $spawn_timer

@export var enemy_scene : PackedScene
@export var spawn_margin = 40

func _ready() -> void:
	Messenger.diminuir_timer.connect(troca_de_wave)

func spawn_enemies():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = calculate_spawn_pos()
	enemy.player = player
	
func calculate_spawn_pos() -> Vector2:
	var screen_size = get_viewport_rect().size
	var player_pos = player.global_position 
	
	var spawn_distance : float = screen_size.length() / 2 + spawn_margin
	
	var angle := randf_range(0, TAU)
	var spawn_pos = player_pos + Vector2.RIGHT.rotated(angle) * spawn_distance
	
	return spawn_pos


func _on_spawn_timer_timeout() -> void:
	spawn_enemies()

func troca_de_wave():
	spawn_timer.wait_time -= 0.1
	Messenger.player_lifes = 5
	Messenger.trocando_de_wave.emit()
