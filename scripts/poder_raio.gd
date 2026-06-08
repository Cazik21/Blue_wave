extends Area2D

@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var damage_timer: float = 0.0

# Mudamos de _process para _physics_process!
func _physics_process(delta: float) -> void:
	# Mantém o feixe apontado para o mouse perfeitamente sincronizado com os corpos
	look_at(get_global_mouse_position())
	
	damage_timer += delta
	if damage_timer >= 0.1:
		causar_dano_continuo()
		damage_timer = 0.0

func causar_dano_continuo():
	# Agora que estamos na física, não precisamos mais resetar o monitoring!
	var corpos_dentro = get_overlapping_bodies()
	
	for body in corpos_dentro:
		if body is CharacterBody2D and body.has_method("take_damage"):
			if body.is_in_group("enemies"):
				body.take_damage(0.25, global_position)
