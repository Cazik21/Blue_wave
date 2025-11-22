extends AnimatedSprite2D

@onready var spawn_timer: Timer = $spawn_floor_enemy

@export var enemy_scene : PackedScene

func _ready() -> void:
	floor_enemy()
	play("1")
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tweenop.connect("finished", delete)

func floor_enemy():
	if Messenger.wave >= 3:
		spawn_timer.start()

func delete():
	floor_enemy()
	queue_free()

func _on_spawn_floor_enemy_timeout() -> void:
	var enemy = enemy_scene.intantiate()
	add_sibling(enemy)
	enemy.global_position = global_position
	floor_enemy()
