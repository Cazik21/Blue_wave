extends Area2D

@export var bullet_speed : float = 125

# Essa variável vai receber o arquivo .tres correto enviado pelo Player!
var data: BulletData 

var direction : Vector2 = Vector2.ZERO
var can_dano_player: bool = false
var main_tween: Tween

@onready var anim: AnimatedSprite2D = $Anim
@onready var collision: CollisionShape2D = $CollisionShape

func _ready() -> void:
	# Segurança: Se a bala nascer sem dados, ela se deleta para não travar o jogo
	if not data:
		push_error("ERRO: A bala nasceu sem os dados do seu Resource!")
		queue_free()
		return
		
	can_dano_player = false
	anim.scale = Vector2(0.6, 0.6)
	collision.scale = Vector2(1, 1)
	self.visible = true
	
	# Usamos o data do recurso para saber qual animação dar Play automaticamente
	anim.play(data.type_name)
	
	# Descontamos a munição usando o seu sistema original do Messenger
	Messenger.balas_q_tenho[Messenger.scroll_pos] -= 1
	
	# Sua lógica original de movimento por Tween que calcula a distância até o clique:
	var travel_distance = global_position.distance_to(get_global_mouse_position())
	direction = (get_global_mouse_position() - global_position).normalized()
	var target_pos = global_position + direction * travel_distance
	var duration = travel_distance / bullet_speed

	main_tween = get_tree().create_tween()
	main_tween.tween_property(self, "global_position", target_pos, duration).set_trans(Tween.TRANS_LINEAR)
	main_tween.finished.connect(bullet_finished)

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func bullet_finished() -> void:
	# Aplica o tamanho final da animação definido lá no seu Resource (.tres)
	anim.scale = data.anim_scale_on_finish
	anim.scale = Vector2(0.8, 0.8) # Mantido do seu código original
	
	# Dá play na animação de onda puxando textualmente o nome do tipo
	anim.play(data.type_name + "_onda")
	
	if has_node("PointLight2D"):
		get_node("PointLight2D").energy = 0
		
	# Expande a colisão da onda usando o tamanho exato configurado no seu Resource
	alterar_colisao(data.wave_scale)
	
	# Fade out suave para sumir com a bala e deletá-la da memória do jogo
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.finished.connect(queue_free)

func wave_delete() -> void:
	queue_free()

func alterar_colisao(_scale: float) -> void:
	main_tween = get_tree().create_tween()
	main_tween.tween_property(collision, "scale", Vector2(_scale, _scale), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemies"):
		kill_tween()
		
		if body.has_method("take_damage"):
			# Se a colisão ainda está no tamanho padrão (1,1), foi impacto direto no ar!
			if collision.scale == Vector2(1, 1):
				body.take_damage(data.direct_damage, global_position) # <-- Adicionado ', global_position'
			else:
				# Se a colisão já cresceu, o inimigo pisou na onda de choque no chão!
				body.take_damage(data.ground_damage, global_position) # <-- Adicionado ', global_position'


func kill_tween() -> void:
	if main_tween and main_tween.is_valid():
		main_tween.kill()
	bullet_finished()
