extends CharacterBody2D

const PARTICLES = preload("uid://vuan0hr8ktyu")

@export var speed : float = 20
@export var health : int = 2
@export var waves_scene : PackedScene

@onready var anim: AnimatedSprite2D = $anim
@onready var reborn_timer: Timer = $"reborn _timer"

var direction : Vector2 = Vector2.ZERO
var player = null
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 160
var animation_playing : bool = false
var can_instantiate_waves : bool = true

var org_color

func _ready() -> void:
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
	await get_tree().create_timer(0.1).timeout
	anim.modulate = org_color

func take_damage(amount: int, sourece_position: Vector2):
	health -= amount
	var knockback_dir = (position - sourece_position).normalized()
	apply_kockback(knockback_dir * 100)
	hit_flash()
	if health <= 0:
		var particles = PARTICLES.instantiate()
		add_sibling(particles)
		particles.global_position = global_position
		particles.rotation = direction.angle() + PI
		Messenger.enemies_f -=1
		queue_free()
		
