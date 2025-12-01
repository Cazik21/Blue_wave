extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var normal = 0
var big = 0
var small = 0
var bomb = 0
var shock = 0
var pipocu : int

func _ready() -> void:
	print(Messenger.balas_q_tenho)
	pipocu = randi_range(1, 1000)
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
	if pipocu%30 <= 10:
		if body.is_in_group("Player"):
				normal += 1
				Messenger.balas_q_tenho.insert(1, normal)
				print(Messenger.balas_q_tenho)

	elif pipocu%30 > 10 and pipocu%30 <= 16:
		if body.is_in_group("Player"):
			big += 1
			Messenger.balas_q_tenho.insert(2, normal)
			print(Messenger.balas_q_tenho)

	elif pipocu%30 > 16 and pipocu%30 <= 22:
		if body.is_in_group("Player"):
			small += 1
			Messenger.balas_q_tenho.insert(3, small)
			print(Messenger.balas_q_tenho)
	
	elif pipocu%30 > 22 and pipocu%30 <= 27:
		if body.is_in_group("Player"):
			bomb += 1
			Messenger.balas_q_tenho.insert(4, bomb)
			print(Messenger.balas_q_tenho)

	else:
		if body.is_in_group("Player"):
			shock += 1
			Messenger.balas_q_tenho.insert(5, shock)
			print(Messenger.balas_q_tenho)
