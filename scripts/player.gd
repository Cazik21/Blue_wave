extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var bullet_scene : PackedScene
@export var waves_scene : PackedScene

var can_shoot : bool = true
var shoot_colldown : float = 0.3
var can_instantiate_waves : bool = true
var walking : bool = false

var org_color

var speed : float = 100

func _ready() -> void:
	Messenger.player = self
	org_color = Color.WHITE

func _physics_process(_delta: float) -> void:
	var mouse_dir = get_global_mouse_position() - global_position
	Messenger.point_to_shoot = get_global_mouse_position()
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot(mouse_dir)
	move()
	create_miniwaves()
	

func move() -> void:
	var direction_vector = Vector2(
		Input.get_action_strength("D") - Input.get_action_strength("A"),
		Input.get_action_strength("S") - Input.get_action_strength("W")
	).normalized()
	
	velocity = direction_vector * speed
	move_and_slide()
	if Vector2(Input.get_action_strength("D") - Input.get_action_strength("A"),Input.get_action_strength("S") - Input.get_action_strength("W")) > Vector2.ZERO: 
		walking = true
		#audio.play()
	elif Vector2(Input.get_action_strength("D") - Input.get_action_strength("A"),Input.get_action_strength("S") - Input.get_action_strength("W")) < Vector2.ZERO:
		walking = true
		#audio.play()
	else:
		walking = false
		#audio.stop()

func shoot(direction):
	can_shoot = false
	
	var bullet_instance = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	
	await get_tree().create_timer(shoot_colldown).timeout
	can_shoot = true
	
func create_miniwaves():
	if can_instantiate_waves and walking:
		can_instantiate_waves = false
		var wave_instance = waves_scene.instantiate()
		get_tree().current_scene.add_child(wave_instance)
		wave_instance.global_position = global_position
		await get_tree().create_timer(0.2).timeout
		can_instantiate_waves = true


func hit_flash():
	anim.modulate = 262626
	await get_tree().create_timer(0.1).timeout
	anim.modulate = org_color

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		hit_flash()
		Messenger.player_lifes -= 1
	if Messenger.player_lifes <= 0:
		Messenger.player_lifes = 5
		Messenger.wave = 1
		get_tree().reload_current_scene()
