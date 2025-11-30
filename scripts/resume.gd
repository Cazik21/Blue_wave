extends Button

func _ready() -> void:
	var empty_style = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", empty_style)
	add_theme_stylebox_override("hover", empty_style)
	add_theme_stylebox_override("pressed", empty_style)
	add_theme_stylebox_override("focus", empty_style)

func _process(_delta: float) -> void:
	if is_hovered():
		Messenger.resume_selecionado.emit()

func _on_pressed() -> void:
	Messenger.voltou_pro_game_brabo.emit()
	Messenger.paused = false
	Messenger.resume.emit()
