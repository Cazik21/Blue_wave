extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $spawn_timer


@export var enemy_scene : PackedScene

@export var pause_menu : PackedScene
@export var spawn_margin = 40

func _ready() -> void:
	Messenger.balas_q_tenho = [32, 0, 0, 0, 0]
	Messenger.diminuir_timer.connect(troca_de_wave)
	Messenger.cena_anterior = "res://scenes/world.tscn"
	if Messenger.paused:
		var pause = pause_menu.instantiate()
		add_child(pause)
		Messenger.paused = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and not Messenger.paused:
		var pause = pause_menu.instantiate()
		add_child(pause)
		Messenger.paused = true

func spawn_enemies():
	if not Messenger.paused:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.global_position = calculate_spawn_pos()
		enemy.player = player
		if randi_range(0, ceil( (Messenger.wave - 7) / 1.06)) == 0 and Messenger.wave > 8:
			enemy.name = "inimigo_atira"
		else:
			enemy.name = "inimigo_normal"

	
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
	spawn_timer.wait_time /= 1.08
	@warning_ignore("integer_division")
	spawn_timer.wait_time = spawn_timer.wait_time + int(Messenger.wave >= 8) / 2
	if Messenger.player_lifes < 5:
		var i = 1
		@warning_ignore("integer_division")
		while Messenger.player_lifes < 5 or i == floor(Messenger.wave / 10) + 1:
			Messenger.player_lifes += 1
			i += 1
	Messenger.trocando_de_wave.emit()
