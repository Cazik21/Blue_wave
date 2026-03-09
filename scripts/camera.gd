extends Camera2D

var tween_in
var tween_out
var shakestrenght = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("charge"):
		tween_in = get_tree().create_tween()
		tween_in.tween_property(self, "zoom",
		 Vector2(1.2, 1.2),
		 1.5)
	else:
		tween_out = get_tree().create_tween()
		tween_out.tween_property(self, "zoom",
		 Vector2(1.0, 1.0),
		 0.7)
	
