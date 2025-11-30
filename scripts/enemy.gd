extends CharacterBody2D

const PARTICLES = preload("uid://vuan0hr8ktyu")

@export var speed : float = 20
@export var health : float = 4
@export var waves_scene : PackedScene
@export var coraco_scene : PackedScene

@onready var anim: AnimatedSprite2D = $anim
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var direction : Vector2 = Vector2.ZERO
var player = null
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 160
var animation_playing : bool = false
var can_instantiate_waves : bool = true

var rng = RandomNumberGenerator.new()
var org_color

func _ready() -> void:
	rng.randomize()
	player = Messenger.player
	org_color = anim.modulate

func _process(delta: float) -> void:
	if knockback_velocity.length() > 1:
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		if player:
			await get_tree().create_timer(0.8).timeout
			anim.play("jumping")
			direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			move_and_slide()
	if can_instantiate_waves:
		can_instantiate_waves = false
		var wave_instance = waves_scene.instantiate()
		get_tree().current_scene.add_child(wave_instance)
		wave_instance.global_position = global_position
		await get_tree().create_timer(0.6).timeout
		can_instantiate_waves = true

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
		if randi_range(23, 23) == 23:
			var coracos = coraco_scene.instantiate()
			coracos.global_position = global_position
			add_sibling(coracos)
			coracos.global_position = global_position
		audio.play()
		self.visible = false
		collision.queue_free()
		await get_tree().create_timer(0.18).timeout
		queue_free()
