extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	Messenger.resume.connect(resume)

func resume():
	Messenger.tree.paused = false
	queue_free()
