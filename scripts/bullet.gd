extends Area2D

@export var bullet_speed : float = 150
var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction.rotated(rotation) * bullet_speed * delta

func set_direction(new_direction):
	direction = new_direction.normalized()

func _on_screen_notifier_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1, global_position)
		self.queue_free()
