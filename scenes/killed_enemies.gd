extends Label

func _process(delta: float) -> void:
	self.text = "Killed Enemies: " + str(Messenger.killed_enemies)
