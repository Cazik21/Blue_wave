extends Control

func _ready() -> void:
	Messenger.resume.connect(resume)

func resume():
	queue_free()
