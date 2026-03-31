extends Camera2D

@onready var light: PointLight2D = $PointLight2D
var pode_luz : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("charge"):
		pode_luz = true
		get_tree().create_tween().tween_property(self, "zoom",
		 Vector2(1.2, 1.2),
		 1.5)
		get_tree().create_tween().tween_property(light, "energy", 0.1, 1.5)
	else:
		get_tree().create_tween().tween_property(light, "energy", 2, 1.5)
		get_tree().create_tween().tween_property(self, "zoom",
		 Vector2(1.0, 1.0),
		 0.7)
