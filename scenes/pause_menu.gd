extends Control

func _ready() -> void:
	Messenger.resume.connect(resume)
	self.get_tree().paused = false

func resume():
	queue_free()
