extends Area2D

@export var bullet_speed : float = 150
var direction : Vector2 = Vector2.ZERO
var distance

func _ready() -> void:
	distance = position.distance_squared_to(Messenger.point_to_shoot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.distance_squared_to(self.get_parent().get_node("Player").position) < distance:
		position += direction.rotated(rotation) * bullet_speed * delta
	else:
		Messenger.ondinhas.emit()

func set_direction(new_direction):
	direction = new_direction.normalized()

func _on_screen_notifier_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1, global_position)
		self.queue_free()
