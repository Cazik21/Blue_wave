extends Button

func _ready() -> void:
	var empty_style = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", empty_style)
	add_theme_stylebox_override("hover", empty_style)
	add_theme_stylebox_override("pressed", empty_style)
	add_theme_stylebox_override("focus", empty_style)

func _process(_delta: float) -> void:
	if is_hovered():
		Messenger.back.emit()

func _on_pressed() -> void:
	Messenger.tree.change_scene_to_file("res://scenes/options.tscn")
