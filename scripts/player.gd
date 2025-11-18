extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 100
var shoot = preload("res://scenes/shoot.tscn")

func _physics_process(_delta: float) -> void:
	Messenger.direction_for_the_shoot = int(anim.flip_h) - int(int(anim.flip_h) == 0)
	move()
	shooting()

func move() -> void:
	var direction_vector = Vector2(
		Input.get_action_strength("D") - Input.get_action_strength("A"),
		Input.get_action_strength("S") - Input.get_action_strength("W")
	).normalized()
	
	velocity = direction_vector * speed
	move_and_slide()

func shooting() -> void:
	Messenger.shoot_direction = Vector2(
		Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left"),
		Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
		)
	print(Messenger.shoot_direction)
	if Messenger.shoot_direction > Vector2(0.0, 0.0):
		var shoot_intantiate = shoot.instantiate()
		add_child(shoot_intantiate)
		print(Messenger.direction_for_the_shoot)
	
	elif Messenger.shoot_direction < Vector2(0.0, 0.0):
		var shoot_intantiate = shoot.instantiate()
		add_sibling(shoot_intantiate)
		shoot_intantiate.global_position = global_position
		print(Messenger.direction_for_the_shoot)
