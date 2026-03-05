extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var light: PointLight2D = $PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.scale = Vector2(1, 1)
	anim.play("power")
	audio.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(collision, "scale",
	 Vector2(4.5, 4.5),
	 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	var tweenop = get_tree().create_tween()
	tweenop.tween_property(self, "modulate",
	 Color("#ffffff", 0),
	 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenop.connect("finished", queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		@warning_ignore("integer_division")
		body.take_damage(4.2 - int(collision.scale > Vector2(4.2, 4.2)), global_position)
