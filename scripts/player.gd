extends CharacterBody2D

var speed = 100

func _physics_process(_delta: float) -> void:
	move()
	shoot()

func move() -> void:
	var direction_vector = Vector2(
		Input.get_action_strength("D") - Input.get_action_strength("A"),
		Input.get_action_strength("S") - Input.get_action_strength("W")
	).normalized()
	
	velocity = direction_vector * speed
	move_and_slide()

func shoot() -> void:
	Messenger.shoot_direction = Vector2(
		Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left"),
		Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
		)
	print(Messenger.shoot_direction)
