extends Control

@onready var killed: Label = $CanvasLayer/killed
@onready var faltantes: Label = $CanvasLayer/faltantes

func _process(_delta: float) -> void:
	killed.text = "Killed Enemies: " + str(Messenger.killed_enemies)
	faltantes.text = "Remaining enemies: " + str(Messenger.enemies_f) 
	if Messenger.tree.paused:
		killed.visible = true
		if Messenger.in_combat:
			faltantes.visible = true
	
	else:
		killed.visible = false
		faltantes.visible = false
