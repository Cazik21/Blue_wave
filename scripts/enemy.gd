extends CharacterBody2D

const PARTICLES = preload("uid://vuan0hr8ktyu")

@export var speed : float = 20
@export var health : float = 4
@export var waves_scene : PackedScene
@export var coraco_scene : PackedScene

@onready var anim: AnimatedSprite2D = $anim
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var safe_delta : float
var direction : Vector2 = Vector2.ZERO
var player = null
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 160
var animation_playing : bool = false
var can_instantiate_waves : bool = true

var rng = RandomNumberGenerator.new()
var org_color
var frame = 0

func _ready() -> void:
	Messenger.org_color_for_enemy = anim.modulate
	Messenger.voltou_pro_game_brabo.connect(voltando_pro_game)
	Messenger.saiu_pq_meno.connect(saiu_pq_meno)
	
	push_out_in_direction(Vector2.RIGHT) #Tem q fazer sistema de qual direcao
	rng.randomize()
	player = Messenger.player
	org_color = anim.modulate
	voltando_pro_game()

func saiu_pq_meno():
	frame = anim.frame

func _physics_process(delta: float) -> void:
	if not Messenger.paused:
		safe_delta = min(delta, 0.05)
		if knockback_velocity.length() > 1:
			velocity = knockback_velocity
			velocity = velocity * safe_delta * 60
			move_and_slide()
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * safe_delta)
		else:
			if player:
				await get_tree().create_timer(0.8).timeout
				anim.play("jumping")
				direction = global_position.direction_to(player.global_position)
				velocity = direction * speed
				velocity = velocity * safe_delta * 60
				move_and_slide()
		if can_instantiate_waves:
			can_instantiate_waves = false
			var wave_instance = waves_scene.instantiate()
			Messenger.tree.current_scene.add_child(wave_instance)
			wave_instance.global_position = global_position
			await Messenger.tree.create_timer(0.6).timeout
			can_instantiate_waves = true
	else:
		anim.stop()
func apply_kockback(force : Vector2):
	knockback_velocity = force

func hit_flash():
	anim.modulate = Color.WHITE
	await Messenger.tree.create_timer(0.1).timeout
	anim.modulate = org_color

func take_damage(amount: float, sourece_position: Vector2):
	health -= amount
	audio.play()
	var knockback_dir = (position - sourece_position).normalized()
	apply_kockback(knockback_dir * 100)
	hit_flash()
	if health <= 0:
		var particles = PARTICLES.instantiate()
		add_sibling(particles)
		particles.global_position = global_position
		particles.rotation = direction.angle() + PI
		Messenger.enemies_f -=1
		if randi_range(1, 23) == 23:
			var coracos = coraco_scene.instantiate()
			coracos.global_position = global_position
			add_sibling(coracos)
			coracos.global_position = global_position
		audio.play()
		self.visible = false
		collision.queue_free()
		await Messenger.tree.create_timer(0.18).timeout
		Messenger.killed_enemies += 1
		queue_free()


@warning_ignore("shadowed_variable")
func push_out_in_direction(direction: Vector2, step := 2.0, max_steps := 50):
	direction = direction.normalized()
	var steps := 0
	
	# Repete enquanto ainda houver colisão naquele movimento
	while test_move(global_transform, direction * step) and steps < max_steps:
		global_position += direction * step
		steps += 1

func voltando_pro_game():
	anim.frame = frame
