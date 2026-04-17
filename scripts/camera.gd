extends Camera2D

@onready var light: PointLight2D = $PointLight2D
var pode_luz : bool = false
var powerando :  bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messenger.powerasso.connect(power1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not powerando:
		if Input.is_action_pressed("charge"):
			pode_luz = true
			zoom_in(Vector2(1.2, 1.2), 1.5)
			get_tree().create_tween().tween_property(light, "energy", 0.1, 1.5)
		else:
			get_tree().create_tween().tween_property(light, "energy", 2, 1.5)
			zoom_out(Vector2(1.0, 1.0), 0.7)

func zoom_in(balor : Vector2, time : float):
	get_tree().create_tween().tween_property(self, "zoom",
	 balor,
	time)

func zoom_out(balor : Vector2, time : float):
	get_tree().create_tween().tween_property(self, "zoom",
	 balor,
	 time)

func power1():
	powerando = true
	zoom_in(Vector2(1.4, 1.4), 0.6)
	await get_tree().create_timer(0.7).timeout
	powerando = false
