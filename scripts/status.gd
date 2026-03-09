extends Control

@onready var killed: Label = $CanvasLayer/killed
@onready var faltantes: Label = $CanvasLayer/faltantes

func _process(_delta: float) -> void:
	killed.text = "Killed Enemies: " + str(Messenger.killed_enemies)
	faltantes.text = "Remaining enemies: " + str(Messenger.enemies_f) 
	if Messenger.paused:
		killed.visible = true
		faltantes.visible = true
	
	else:
		killed.visible = false
		faltantes.visible = false
