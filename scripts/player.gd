extends CharacterBody2D

#region @onready's
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var point_light_2d: PointLight2D = $Camera/PointLight2D
@onready var audio2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var collision_p: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var hurtbox: Area2D = $hurtbox
@onready var collision_hurt: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var timer_dano: Timer = $TimerDano
@onready var energy_particles: CPUParticles2D = $"player_energy particles"
@onready var timer_dash: Timer = $Timer_dash
@onready var dash_audio: AudioStreamPlayer2D = $dash
#endregion

#region @export's
@export var bullet_scene : PackedScene
@export var waves_scene : PackedScene
@export var enemy_scene : PackedScene
@export var powerasso : PackedScene
#endregion

#region var's
var wait_time_for_ground_enemys : float = 3
var can_shoot : bool = true
var shoot_colldown : float = 0.3
var can_instantiate_waves : bool = true
var walking : bool = false
var enemy = null
var direction_vector
var safe_delta : float
var org_color
var speed : float = 100
var can_dano : bool = true
var can_dash : bool = true
var can_particuzoles_exploideidesdess : bool = false
var mouse_dentro : bool = false
#endregion

func _ready() -> void:
	Messenger.powerasso.connect(powerzasso)
	timer.wait_time = wait_time_for_ground_enemys
	reinice_timer()
	Messenger.dano_player.connect(dano_player)
	if OS.get_name() == "macOS":
		point_light_2d.energy = 2
	else:
		point_light_2d.energy = 1
	Messenger.player = self
	org_color = Color.WHITE

func _physics_process(delta: float) -> void:
	safe_delta = min(delta, 0.033)
	move()
	if Input.is_action_just_pressed("shoot") and can_shoot and not mouse_dentro:
		shoot()
	
	if Input.is_action_just_pressed("dash") and not Input.is_action_pressed("charge"):
		dash()
	create_miniwaves()
	if Input.is_action_pressed("charge") or can_particuzoles_exploideidesdess:
		energy_particles.emitting = true
	
	elif can_dash or not can_particuzoles_exploideidesdess:
		energy_particles.emitting = false

func move() -> void:
	if Messenger.player_lifes > 0 and not Input.is_action_pressed("charge"):
		direction_vector = Input.get_vector("A", "D", "W", "S").normalized()
		
		velocity = direction_vector * speed * safe_delta * 60
		move_and_slide()
		if Vector2(Input.get_action_strength("D") - Input.get_action_strength("A"),Input.get_action_strength("S") - Input.get_action_strength("W")) > Vector2.ZERO: 
			walking = true
		elif Vector2(Input.get_action_strength("D") - Input.get_action_strength("A"),Input.get_action_strength("S") - Input.get_action_strength("W")) < Vector2.ZERO:
			walking = true
		else:
			walking = false
	else:
		create_miniwaves()

func shoot():
	if Messenger.player_lifes > 0:
		if Messenger.balas_q_tenho[Messenger.scroll_pos] > 0:
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

func _on_hurtbox_body_entered(body : CharacterBody2D) -> void:
	if body.is_in_group("enemies"):
		dano_player(1)

func dano_player(amont : int):
	if can_dano:
		Messenger.player_lifes -= amont
		if Messenger.player_lifes <= 0:
			Engine.time_scale = 0.2
			collision_hurt.queue_free()
			await  get_tree().create_timer(0.6).timeout
			Engine.time_scale = 1
			Messenger.player_lifes = 5
			Messenger.wave = 1
			Messenger.killed_enemies = 0
			Messenger.tree.reload_current_scene()
			timer_dano.start()

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

func _on_hurtbox_body_exited(_body: CharacterBody2D) -> void:
	can_dano = true

func _on_timer_dano_timeout() -> void:
	can_dano = true

func powerzasso():
	can_particuzoles_exploideidesdess = true
	get_tree().create_tween().tween_property(point_light_2d, "energy", 35, 0.8)
	var power_wave = powerasso.instantiate()
	get_tree().current_scene.add_child(power_wave)
	power_wave.global_position = global_position
	await get_tree().create_timer(1).timeout
	can_particuzoles_exploideidesdess = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		dano_player(1)

func dash():
	if can_dash:
		energy_particles.emitting = true
		dash_audio.play()
		can_dash = false
		speed = 300
		await get_tree().create_timer(0.1).timeout
		speed = 100
		energy_particles.emitting = false
		timer_dash.start()

func _on_timer_dash_timeout() -> void:
	can_dash = true


func _on_area_mouse_mouse_entered() -> void:
	mouse_dentro = true

func _on_area_mouse_mouse_exited() -> void:
	mouse_dentro = false
