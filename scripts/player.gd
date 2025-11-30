extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var audio2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

@export var bullet_scene : PackedScene
@export var waves_scene : PackedScene
@export var enemy_scene : PackedScene

var wait_time_for_ground_enemys : float = 3
var can_shoot : bool = true
var shoot_colldown : float = 0.3
var can_instantiate_waves : bool = true
var walking : bool = false

var org_color

var speed : float = 100

func _ready() -> void:
	timer.wait_time = wait_time_for_ground_enemys
	reinice_timer()
	Messenger.dano_player.connect(dano_player)
	if OS.get_name() == "macOS":
		point_light_2d.energy = 2
	else:
		point_light_2d.energy = 1
	Messenger.player = self
	org_color = Color.WHITE

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
	move()
	create_miniwaves()

func move() -> void:
	if Messenger.player_lifes > 0:
		var direction_vector = Vector2(
			Input.get_action_strength("D") - Input.get_action_strength("A"),
			Input.get_action_strength("S") - Input.get_action_strength("W")
		).normalized()
	
		velocity = direction_vector * speed
		move_and_slide()
		if Vector2(Input.get_action_strength("D") - Input.get_action_strength("A"),Input.get_action_strength("S") - Input.get_action_strength("W")) > Vector2.ZERO: 
			walking = true
		elif Vector2(Input.get_action_strength("D") - Input.get_action_strength("A"),Input.get_action_strength("S") - Input.get_action_strength("W")) < Vector2.ZERO:
			walking = true
		else:
			walking = false

func shoot():
	if Messenger.player_lifes > 0:
		can_shoot = false
		audio.play()
		var bullet_instance = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_position = global_position
	
		await get_tree().create_timer(shoot_colldown).timeout
		can_shoot = true

func create_miniwaves():
	if can_instantiate_waves and walking:
		can_instantiate_waves = false
		var wave_instance = waves_scene.instantiate()
		get_tree().current_scene.add_child(wave_instance)
		wave_instance.global_position = global_position
		if randi_range(1, 20) == 1 and Messenger.can_spawn_enemy == 1:
			spawn_grounded_enemy()
		await get_tree().create_timer(0.2).timeout
		can_instantiate_waves = true

func hit_flash():
	anim.modulate = 262626 #Chris pq 262626?
	await get_tree().create_timer(0.1).timeout
	anim.modulate = org_color

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		hit_flash()
		Messenger.player_lifes -= 1
		audio2.play()
	if Messenger.player_lifes <= 0:
		Messenger.player_lifes = 5
		Messenger.wave = 1
		get_tree().reload_current_scene()

func dano_player():
	hit_flash()
	Messenger.player_lifes -= 1
	audio2.play()
	if Messenger.player_lifes <= 0:
		Engine.time_scale = 0.2
		collision.queue_free()
		await  get_tree().create_timer(0.6).timeout
		Engine.time_scale = 1
		Messenger.player_lifes = 5
		Messenger.wave = 1
		get_tree().reload_current_scene()

func reinice_timer():
	Messenger.can_spawn_enemy = 0
	timer.start()


func spawn_grounded_enemy():
	if Messenger.wave >= 5:
		reinice_timer()
		var globa_position = global_position
		await get_tree().create_timer(1).timeout
		var new_enemy_scene = enemy_scene.instantiate()
		new_enemy_scene.global_position = globa_position
		add_sibling(new_enemy_scene)
		new_enemy_scene.get_node("anim").modulate = Color.WHITE
		await get_tree().create_timer(0.8).timeout
		new_enemy_scene.get_node("anim").modulate = Messenger.org_color_for_enemy


func _on_timer_timeout() -> void:
	Messenger.can_spawn_enemy = 1
