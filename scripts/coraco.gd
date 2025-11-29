extends Node2D

var timer : float = 0
var tween_finished : bool = false

func _ready() -> void:
	self.z_index = 3
	var tweenypos = get_tree().create_tween()
	tweenypos.tween_property(self, "global_position",
	 Vector2(global_position.x, global_position.y - 10),
	 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tweenypos.connect("finished", finished)

func finished():
	tween_finished = true

func _process(delta: float) -> void:
	if tween_finished:
		timer += delta
		position.y += sin(timer * 4)/20


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		var tweenop = get_tree().create_tween()
		tweenop.tween_property(self, "modulate",
		 Color("ffffff", 0),
		 0.3)
		tweenop.connect("finished", queue_free)
		Messenger.player_lifes += 1
