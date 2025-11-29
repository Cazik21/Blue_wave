extends Area2D

@export var bullet_speed : float = 125

var direction : Vector2 = Vector2.ZERO
var target_pos

@onready var anim: AnimatedSprite2D = $Anim
@onready var collision: CollisionShape2D = $CollisionShape
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


var can_dano_player: bool = false

func _ready() -> void:
	can_dano_player = false
	anim.scale = Vector2(0.6, 0.6)
	collision.scale =Vector2(1, 1)
	self.visible = true
	anim.play("bullet")
	global_position = self.get_parent().get_node("Player").global_position
	# 1. Direção da bala
	direction = (get_global_mouse_position() - global_position).normalized()

	# 2. Distância fixa de viagem
	var travel_distance = global_position.distance_to(get_global_mouse_position())
	target_pos = global_position + direction * travel_distance

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
	anim.scale = Vector2(1.5, 1.5)
	alterar_colisao()
	anim.play("default_wave")
	audio.play()
	self.get_node("PointLight2D").energy = 0
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", wave_delete)
	can_dano_player = true
	dar_dano()

func wave_delete():
	self.queue_free()

func alterar_colisao():
	var tween2 = get_tree().create_tween()
	tween2.tween_property(collision, "scale",
	 Vector2(7, 7),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1, global_position)
<<<<<<< HEAD
<<<<<<< HEAD

=======
<<<<<<< Updated upstream
=======
>>>>>>> sounds

func equacao_q_n_lembro(vector1, vector2) -> float:
	return sqrt(((vector1.x - vector2.x) ** 2) + ((vector1.y - vector2.y) ** 2))

func dar_dano():
	pass
	if equacao_q_n_lembro(get_parent().get_node("Player").position, self.position) < 17 and can_dano_player:
		Messenger.dano_player.emit()
<<<<<<< HEAD
=======
=======

>>>>>>> Stashed changes
>>>>>>> sounds
		anim.play("default_wave")
		audio.play()
		self.get_node("PointLight2D").energy = 0
		var tweenop = get_tree().create_tween()
		tweenop.tween_property(self, "modulate",
		 Color("#ffffff", 0),
		 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		target_pos = global_position
		tweenop.connect("finished", wave_delete)
>>>>>>> sounds
