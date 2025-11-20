extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var bullet_scene : PackedScene

var can_shoot : bool = true
var shoot_colldown : float = 0.3

var speed : float = 100

func _ready() -> void:
	Messenger.player = self

func _physics_process(_delta: float) -> void:
	var mouse_dir = get_global_mouse_position() - global_position
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot(mouse_dir)
	move()

func move() -> void:
	var direction_vector = Vector2(
		Input.get_action_strength("D") - Input.get_action_strength("A"),
		Input.get_action_strength("S") - Input.get_action_strength("W")
	).normalized()
	
	velocity = direction_vector * speed
	move_and_slide()

func shoot(direction):
	can_shoot = false
	
	var bullet_instance = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	
	await get_tree().create_timer(shoot_colldown).timeout
	can_shoot = true
