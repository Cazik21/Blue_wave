extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var light: PointLight2D = $Light

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	collision.position = anim.position
	if Input.is_action_pressed("charge"):
		anim.flip_v = true
		get_tree().create_tween().tween_property(anim, "position", Vector2(47, 0), 0.3)
	else:
		anim.flip_v = false
		get_tree().create_tween().tween_property(anim, "position", Vector2(-47, 0), 0.3)
