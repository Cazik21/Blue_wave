extends Node2D

var timer : float = 0

func _ready() -> void:
	self.get_node("Label").text = str(Messenger.coraco_valor)


func _process(delta: float) -> void:
	timer += delta
	position.y += sin(timer)/100


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		Messenger.player_lifes += Messenger.coraco_valor
		queue_free()
