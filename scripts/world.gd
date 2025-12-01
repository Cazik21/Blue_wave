extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $spawn_timer


@export var enemy_scene : PackedScene
@export var enemyqatira_scene : PackedScene
@export var pause_menu : PackedScene
@export var spawn_margin = 40

func _ready() -> void:
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
		if randi_range(1, 20) == 20 and Messenger.wave > 4:
			var enemyqatira = enemyqatira_scene.instantiate()
			add_child(enemyqatira)
			enemyqatira.global_position = calculate_spawn_pos()
			enemyqatira.player = player
			enemyqatira.name = "inimigo_atira"
			
		else:
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
		Messenger.balas_q_tenho[1] += 32
	Messenger.balas_q_tenho[2] += 10
	Messenger.balas_q_tenho[3] += 10
	Messenger.balas_q_tenho[4] += 10
	Messenger.balas_q_tenho[5] += 5
	spawn_timer.wait_time /= 1.19
	@warning_ignore("integer_division")
	spawn_timer.wait_time = spawn_timer.wait_time + int(Messenger.wave >= 5)/2
	if Messenger.player_lifes < 5:
		var i = 1
		@warning_ignore("integer_division")
		while Messenger.player_lifes < 5 or i == int(Messenger.wave / 10) + 1:
			Messenger.player_lifes += 1
			i += 1
	Messenger.trocando_de_wave.emit()
