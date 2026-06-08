extends Control

#region @onready's
@onready var progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var animation: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var particles: CPUParticles2D = $CanvasLayer/ChargeParticles
@onready var particles2: CPUParticles2D = $CanvasLayer/ChargeParticles2
@onready var timer: Timer = $Timer
@onready var decresing_particles: CPUParticles2D = $CanvasLayer/DecresingParticles
#endregion

var laser_ativo : bool = false

func _ready() -> void:
	Messenger.powerasso.connect(animationzinha_descendo_a_barra.bind(9.0))
	Messenger.escudozasso.connect(animationzinha_descendo_a_barra.bind(64))
	
	if Messenger.has_signal("lazerrasso_terminou"):
		Messenger.lazerrasso_terminou.connect(desligar_laser)
	
	decresing_particles.emitting = false
	particles.emitting = false
	particles2.emitting = false

func _process(delta: float) -> void:
	# Atualiza a posição das partículas baseado no valor atual
	var pos_y = map_value(progress_bar.value)
	decresing_particles.position.y = pos_y
	particles.position.y = pos_y
	particles2.position.y = pos_y
	
	# === ESTADO 1: LASER ATIVO ===
	if laser_ativo:
		# Força as partículas de carga a sumirem enquanto gasta energia
		particles.emitting = false
		particles2.emitting = false
		
		if progress_bar.value > 9:
			decresing_particles.emitting = true
			progress_bar.value -= 8.3 * delta
		else:
			desligar_laser()
		
		# IMPEDE que o resto do código de carga ou de usar outros poderes rode
		return 

	# === ESTADO 2: COMPORTAMENTO PADRÃO (SÓ RODA SE O LASER NÃO ESTIVER ATIVO) ===
	
	# Gatilho para ligar o laser (power3)
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power3") and not Input.is_action_pressed("charge"):
		laser_ativo = true
		Messenger.lazerrasso.emit()
		return # Sai da função para começar o gasto puro no próximo frame

	# Outros poderes de clique único
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power1"):
		Messenger.powerasso.emit()
	
	if progress_bar.value >= 92 and Input.is_action_just_pressed("power2"):
		Messenger.escudozasso.emit()
		
	# Controle visual da animação do raio pulando
	if progress_bar.value >= 92:
		particles.emitting = false
		particles2.emitting = false
		animation.play("bar_cheia")
	else:
		animation.play("parado")

	# Controle do botão de carga
	if Input.is_action_just_pressed("charge"):
		timer.start()

	if Input.is_action_just_released("charge"):
		timer.stop()
		particles.emitting = false
		particles2.emitting = false


func map_value(value):
	var min1 = 14.0
	var max1 = 92.0
	var min2 = 108.0
	var max2 = 82.0
	
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1)

func _on_timer_timeout() -> void:
	# O loop só continua se estiver segurando a carga E o laser não foi ligado
	while Input.is_action_pressed("charge") and not laser_ativo:
		if laser_ativo: 
			break # Quebra o loop imediatamente se o laser ligar no frame
			
		await get_tree().create_timer(get_process_delta_time()).timeout
		
		# Verificação dupla obrigatória após o "await" para impedir o frame fantasma
		if not laser_ativo and Input.is_action_pressed("charge"):
			particles.emitting = true
			particles2.emitting = true
			progress_bar.value += progress_bar.step

func animationzinha_descendo_a_barra(balor):
	decresing_particles.emitting = true
	while progress_bar.value > balor:
		await get_tree().create_timer(get_process_delta_time()).timeout
		progress_bar.value -= 5
	decresing_particles.emitting = false

func desligar_laser() -> void:
	laser_ativo = false
	decresing_particles.emitting = false
	animation.play("parado")
