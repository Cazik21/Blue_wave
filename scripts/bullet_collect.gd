extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@export var max_bullets : PackedScene

var array1 : Array = ["normal", "big", "small", "bomb", "shock"]
var pipocu : int

func _ready() -> void:
	pipocu = randi_range(1, 10000)
	if pipocu%30 <= 10:
		collision.scale = Vector2(0.45, 0.45)
		anim.play("normal")

	elif pipocu%30 > 10 and pipocu%30 <= 16:
		collision.scale = Vector2(0.9, 0.9)
		anim.play("big")

	elif pipocu%30 > 16 and pipocu%30 <= 22:
		collision.scale = Vector2(0.3, 0.3)
		anim.play("small")

	elif pipocu%30 > 22 and pipocu%30 <= 27:
		collision.scale = Vector2(0.6, 0.6)
		anim.play("bomb")

	else:
		collision.scale = Vector2(0.45, 0.45)
		anim.play("shock")


func _on_body_entered(body: CharacterBody2D) -> void:
	if Messenger.balas_q_tenho[array1.find(anim.animation)] < 32:
		if anim.animation == "normal":
			if body.is_in_group("Player"):
					Messenger.balas_q_tenho[0] = Messenger.balas_q_tenho[0] + 1

		elif anim.animation == "big":
			if body.is_in_group("Player"):
				Messenger.balas_q_tenho[1] = Messenger.balas_q_tenho[1] + 1

		elif anim.animation == "small":
			if body.is_in_group("Player"):
				Messenger.balas_q_tenho[2] = Messenger.balas_q_tenho[2] + 1
		
		elif anim.animation == "bomb":
			if body.is_in_group("Player"):
				Messenger.balas_q_tenho[3] = Messenger.balas_q_tenho[3] + 1

		elif anim.animation == "shock":
			if body.is_in_group("Player"):
				Messenger.balas_q_tenho[4] = Messenger.balas_q_tenho[4] + 1
		queue_free()
	else:
		Messenger.max_bulletas.emit()
	
