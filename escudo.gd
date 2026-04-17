extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	get_tree().create_tween().tween_property(self, "global_position", get_parent().get_child(2).global_position, 0.2)
	look_at(get_global_mouse_position())
	collision.position = anim.position
	if Input.is_action_pressed("charge"):
		anim.flip_v = true
		get_tree().create_tween().tween_property(anim, "position", Vector2(47, 0), 0.3)
	else:
		anim.flip_v = false
		get_tree().create_tween().tween_property(anim, "position", Vector2(-47, 0), 0.3)

func _on_timer_timeout() -> void:
	var tween_op = get_tree().create_tween()
	tween_op.tween_property(self, "modulate", Color("ffffff00"), 1.5)
	var tween_scale = get_tree().create_tween()
	tween_scale.tween_property(self, "scale", Vector2(0.1, 0.1), 1.3)
	tween_scale.connect("finished", queue_free)
