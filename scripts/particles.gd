extends CPUParticles2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio.play()

func _on_timer_timeout() -> void:
	set_physics_process(false)
	set_process(false)
	set_process_internal(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	await get_tree().create_timer(20).timeout
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tweenop.connect("finished", delete)
	
func delete():
	queue_free()
	
