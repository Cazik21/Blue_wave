extends Area2D

@export var bullet_speed : float = 125
var direction : Vector2 = Vector2.ZERO

@onready var anim: AnimatedSprite2D = $Anim
@onready var collision: CollisionShape2D = $CollisionShape

var can_dano_player: bool = false
var tween

func _ready() -> void:
	name = Messenger.type_of_the_bullet
	anim.play(name)
	can_dano_player = false
	anim.scale = Vector2(0.6, 0.6)
	collision.scale =Vector2(1, 1)
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
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)\
		.set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(bullet_finished)

func set_direction(new_direction):
	direction = new_direction.normalized()

func bullet_finished() -> void:
	anim.scale = Vector2(0.8, 0.8)
	alterar_colisao()
	anim.play(name + "_onda")
	self.get_node("PointLight2D").energy = 0
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", queue_free)


func wave_delete():
	self.queue_free()

func alterar_colisao():
	tween = get_tree().create_tween()
	tween.tween_property(collision, "scale",
	 Vector2(7, 7),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_body_entered(body: CharacterBody2D) -> void:

	if body.is_in_group("enemies"):
		kill_tween()
		@warning_ignore("integer_division")
		body.take_damage(2 - int(collision.scale > Vector2(1, 1)), global_position)


func equacao_q_n_lembro(vector1, vector2) -> float:
	return sqrt(((vector1.x - vector2.x) ** 2) + ((vector1.y - vector2.y) ** 2))



func kill_tween():
	tween.kill()
	bullet_finished()
