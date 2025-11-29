extends AnimatedSprite2D

@onready var spawn_timer: Timer = $spawn_floor_enemy

@export var enemy_scene : PackedScene

func _ready() -> void:
	play("1")
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", delete)

func delete():
	queue_free()
