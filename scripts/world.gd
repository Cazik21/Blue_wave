extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var spawn_timer: Timer = $spawn_timer

@export var enemy_scene : PackedScene
@export var pause_menu : PackedScene
@export var spawn_margin = 40

func _ready() -> void:
	Messenger.enemies_f = 3
	Messenger.enemies_p_wave = 3
	Messenger.balas_q_tenho = [32, 0, 0, 0, 0]
	Messenger.diminuir_timer.connect(troca_de_wave)
	Messenger.cena_anterior = "res://scenes/world.tscn"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and not Messenger.tree.paused:
		get_tree().paused = true
		var pause = pause_menu.instantiate()
		add_child(pause)


func spawn_enemies():
	if Messenger.in_combat:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.global_position = calculate_spawn_pos()
		enemy.player = player
		if randi_range(0, 18) == 0 and Messenger.wave > 2:
			enemy.name = "inimigo_atira"
		else:
			enemy.name = "inimigo_normal"

	
func calculate_spawn_pos() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	var screen_size = get_viewport_rect().size
	
	# Posição padrão caso não encontre a câmera (centro da arena ou player)
	var cam_global_pos = player.global_position
	
	if camera:
		# Pega a posição global exata do nó da câmera no mundo
		cam_global_pos = camera.global_position
	
	# Definimos as "metades" da tela para saber onde as bordas começam
	var half_width = (screen_size.x / 2) + spawn_margin
	var half_height = (screen_size.y / 2) + spawn_margin
	
	# Escolhe aleatoriamente uma das 4 bordas (0: Topo, 1: Baixo, 2: Esquerda, 3: Direita)
	var border = randi_range(0, 3)
	var spawn_pos = Vector2.ZERO
	
	match border:
		0: # Topo (Acima da visão da câmera)
			spawn_pos.x = randf_range(cam_global_pos.x - half_width, cam_global_pos.x + half_width)
			spawn_pos.y = cam_global_pos.y - half_height
		1: # Baixo (Abaixo da visão da câmera)
			spawn_pos.x = randf_range(cam_global_pos.x - half_width, cam_global_pos.x + half_width)
			spawn_pos.y = cam_global_pos.y + half_height
		2: # Esquerda (À esquerda da visão da câmera)
			spawn_pos.x = cam_global_pos.x - half_width
			spawn_pos.y = randf_range(cam_global_pos.y - half_height, cam_global_pos.y + half_height)
		3: # Direita (À direita da visão da câmera)
			spawn_pos.x = cam_global_pos.x + half_width
			spawn_pos.y = randf_range(cam_global_pos.y - half_height, cam_global_pos.y + half_height)
			
	return spawn_pos


func _on_spawn_timer_timeout() -> void:
	spawn_enemies()

func troca_de_wave():
	
	if Messenger.balas_q_tenho[0] + 32 > 48:
		Messenger.balas_q_tenho[0] = 48
	else:
		Messenger.balas_q_tenho[0] += 32
	
	if Messenger.balas_q_tenho[1] + 10 > 48:
		Messenger.balas_q_tenho[1] = 48
	else:
		Messenger.balas_q_tenho[1] += 10
	
	if Messenger.balas_q_tenho[2] + 10 > 48:
		Messenger.balas_q_tenho[2] = 48
	else:
		Messenger.balas_q_tenho[2] += 10
	
	if Messenger.balas_q_tenho[3] + 10 > 48:
		Messenger.balas_q_tenho[3] = 48
	else:
		Messenger.balas_q_tenho[3] += 10
	
	if Messenger.balas_q_tenho[4] + 5 > 48:
		Messenger.balas_q_tenho[4] = 48
	else:
		Messenger.balas_q_tenho[4] += 5
	
	spawn_timer.wait_time /= 1.19
	@warning_ignore("integer_division")
	spawn_timer.wait_time = spawn_timer.wait_time + int(Messenger.wave >= 4) / 2
	if Messenger.player_lifes < 5:
		var i = 1
		@warning_ignore("integer_division")
		while Messenger.player_lifes < 5 or i == floor(Messenger.wave / 10) + 1:
			Messenger.player_lifes += 1
			i += 1
	Messenger.trocando_de_wave.emit()
