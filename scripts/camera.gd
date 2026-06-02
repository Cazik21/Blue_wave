extends Camera2D

@onready var light: PointLight2D = $PointLight2D
@onready var audio: AudioStreamPlayer2D = $Audio
var pode_luz : bool = false
var powerando :  bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messenger.powerasso.connect(power1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Messenger.in_combat:
		limit_left = Messenger.player_pos_no_combat.x - 208.0
		limit_top = Messenger.player_pos_no_combat.y - 117.0
		limit_right = Messenger.player_pos_no_combat.x + 208.0
		limit_bottom = Messenger.player_pos_no_combat.y + 117.0
	else:
		limit_left = -100000
		limit_top = -100000
		limit_right = 100000
		limit_bottom = 100000
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
	zoom_in(Vector2(1.165, 1.165), 0.8)
	await get_tree().create_timer(0.8).timeout
	powerando = false
