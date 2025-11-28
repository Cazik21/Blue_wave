extends Area2D

@export var ondas : PackedScene
@export var bullet_speed : float = 125
var direction : Vector2 = Vector2.ZERO


func _ready() -> void:
	self.visible = true
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
	tween.finished.connect(bullet_finished)

func set_direction(new_direction):
	direction = new_direction.normalized()

func bullet_finished() -> void:
	self.get_node("Sprite").visible = false
	var ondas_new_instance = ondas.instantiate()
	add_child(ondas_new_instance)
	ondas_new_instance.global_position = global_position
	ondas_new_instance.visible = true
	self.get_node("PointLight2D").energy = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1, global_position)
		self.queue_free()
