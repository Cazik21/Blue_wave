extends Camera2D

var tween_in
var tween_out
var shakestrenght = 0.0

const INITIALSTRENGHT = 15.0
const SHAKEFADE = 9.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shake()

func shake():
	shakestrenght = INITIALSTRENGHT

func randomOffset() -> Vector2:
	return Vector2(randf_range(-shakestrenght, shakestrenght),
	 randf_range(shakestrenght, -shakestrenght))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shake()
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
	
	shakestrenght = lerp(shakestrenght, 0.0, SHAKEFADE * delta)
