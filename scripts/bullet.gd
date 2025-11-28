extends Area2D

@export var bullet_speed : float = 150
var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	global_position = self.get_parent().get_node("Player").global_position
	# 1. Direção da bala
	direction = (get_global_mouse_position() - global_position).normalized()

	# 2. Distância fixa de viagem
	var travel_distance = global_position.distance_to(get_global_mouse_position())
	var target_pos = global_position + direction * travel_distance

	# 3. Duração baseada em VELOCIDADE
	var duration = travel_distance / bullet_speed

	# 4. Tween linear com velocidade constante
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)\
		.set_trans(Tween.TRANS_LINEAR)



func _process(delta: float) -> void:
	pass
	#if position.distance_to(self.get_parent().get_node("Player").position) < distance:
		#position += direction.rotated(rotation) * bullet_speed * delta
	#else:
		#Messenger.ondinhas.emit()

func set_direction(new_direction):
	direction = new_direction.normalized()

func _on_screen_notifier_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1, global_position)
		self.queue_free()
