extends Area2D

@export var bullet_speed : float = 125
var direction : Vector2 = Vector2.ZERO

@onready var anim: AnimatedSprite2D = $Anim
@onready var collision: CollisionShape2D = $CollisionShape

var dano_das_balas : Array = [2, 1, 4, 3, 3]
var array1 : Array = ["normal", "big", "small", "bomb", "shock"]
var scale_of_bullet : Array = [7, 15, 5, 15, 25]
var tween
var type_da_bala
var index_of_type
var target_pos
var duration

func _ready() -> void:
	if name.contains("bullet"):
		type_da_bala = Messenger.type_of_the_bullet
		index_of_type = array1.find(type_da_bala)
		Messenger.balas_q_tenho[Messenger.scroll_pos] -= 1
	else:
		type_da_bala = "normal"
		index_of_type = 1
	anim.play(type_da_bala)
	anim.scale = Vector2(0.6, 0.6)
	collision.scale =Vector2(1, 1)
	self.visible = true
	if name.contains("bullet"):
		global_position = self.get_parent().get_node("Player").global_position
		# 1. Direção da bala
		direction = (get_global_mouse_position() - global_position).normalized()

		# 2. Distância fixa de viagem
		var travel_distance = global_position.distance_to(get_global_mouse_position())
		target_pos = global_position + direction * travel_distance
		# 3. Duração baseada em VELOCIDADE
		duration = travel_distance / bullet_speed
	else:
		direction = (Messenger.player.global_position - global_position).normalized()
		# 2. Distância fixa de viagem
		var travel_distance = global_position.distance_to(Messenger.player.global_position)
		target_pos = global_position + direction * travel_distance
		# 3. Duração baseada em VELOCIDADE
		duration = travel_distance / bullet_speed

	# 4. Tween linear com velocidade constante
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)\
		.set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(bullet_finished)

func set_direction(new_direction):
	direction = new_direction.normalized()

func bullet_finished() -> void:
	if type_da_bala == "bomb":
		anim.scale = Vector2(1.5, 1.5)
	else:
		anim.scale = Vector2(1, 1)
	anim.scale = Vector2(0.8, 0.8)
	alterar_colisao(scale_of_bullet[index_of_type])
	anim.play(type_da_bala + "_onda")
	self.get_node("PointLight2D").energy = 0
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", queue_free)


func wave_delete():
	self.queue_free()

func alterar_colisao(_scale):
	tween = get_tree().create_tween()
	tween.tween_property(collision, "scale",
	 Vector2(_scale, _scale),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemies"):
		kill_tween()
		@warning_ignore("integer_division")
		body.take_damage(2 - int(collision.scale > Vector2(1, 1)), global_position)
	if body.is_in_group("Player") and not name.contains("bullet"):
		body.dano_player(1)



func kill_tween():
	tween.kill()
	bullet_finished()
