extends CharacterBody2D

const PARTICLES = preload("res://prefabs/particles.tscn")

@export var speed : float = 20
@export var health : float = 4
@export var waves_scene : PackedScene
@export var coraco_scene : PackedScene

@onready var anim: AnimatedSprite2D = $anim
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision: CollisionShape2D = $CollisionShape2D


var esta_atirando : bool = false
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
	anim.play("jumping")
	Messenger.org_color_for_enemy = anim.modulate
	Messenger.voltou_pro_game_brabo.connect(voltando_pro_game)
	Messenger.saiu_pq_meno.connect(saiu_pq_meno)
	
	rng.randomize()
	player = Messenger.player
	org_color = anim.modulate
	voltando_pro_game()

func saiu_pq_meno():
	frame = anim.frame

func _physics_process(_delta: float) -> void:
	if not Messenger.paused:
		if global_position.distance_to(Messenger.tree.current_scene.get_node("Player").global_position) < 100 and name.contains("inimigo_atira"):
			esta_atirando = true
		if esta_atirando == false:
			nao_atirar()
		else:
			atirar()

func atirar():
	safe_delta = min(get_process_delta_time(), 0.03)
	if player:
		direction = global_position.direction_to(player.global_position)
	else:
		anim.stop()


func nao_atirar():
	safe_delta = min(get_process_delta_time(), 0.03)
	if knockback_velocity.length() > 1:
		velocity = knockback_velocity
		velocity = velocity * safe_delta * 60
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * safe_delta)
	else:
		if player:
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


func desconect():
	anim.animation_finished.disconnect(anim.play)

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


func voltando_pro_game():
	anim.frame = frame
