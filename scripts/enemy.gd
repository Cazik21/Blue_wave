extends CharacterBody2D

@export var speed : float = 20
@export var health : int = 2
@onready var anim: AnimatedSprite2D = $anim

var direction : Vector2 = Vector2.ZERO
var player = null
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 160
var animation_playing : bool = false

var org_color = Color.WHITE

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

func apply_kockback(force : Vector2):
	knockback_velocity = force

func hit_flash():
	anim.modulate

func take_damage(amount: int, sourece_position: Vector2):
	health -= amount
	var knockback_dir = (global_position - sourece_position).normalized()
	apply_kockback(knockback_dir * 80)
	if health <= 0:
		queue_free()

func entering_in_safe_area():
	anim.play("desborn")
	queue_free()
