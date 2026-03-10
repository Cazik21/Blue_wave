extends Button


func _ready() -> void:
	var empty_style = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", empty_style)
	add_theme_stylebox_override("hover", empty_style)
	add_theme_stylebox_override("pressed", empty_style)
	add_theme_stylebox_override("focus", empty_style)

func _process(_delta: float) -> void:
	if is_hovered():
		Messenger.quit_selecionado.emit()
		if Input.is_action_just_pressed("select"):
			_on_pressed()

func _on_pressed() -> void:
	Messenger.tree.quit()
