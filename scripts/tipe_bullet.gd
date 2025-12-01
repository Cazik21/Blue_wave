extends AnimatedSprite2D

var scroll_pos = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scoll_up"):
		if not scroll_pos > 5:
			scroll_pos += 1
		else:
			scroll_pos = 1
	
	if Input.is_action_just_pressed("scroll_down"):
		if not scroll_pos < 1:
			scroll_pos -= 1
		else:
			scroll_pos = 5
	
	if  scroll_pos == 1:
		Messenger.type_of_the_bullet = "normal"
	
	if scroll_pos == 2:
		Messenger.type_of_the_bullet = "big"
	
	if scroll_pos == 3:
		Messenger.type_of_the_bullet = "small"
	
	if scroll_pos == 4:
		Messenger.type_of_the_bullet = "bomb"
	
	if scroll_pos == 5:
		Messenger.type_of_the_bullet =  "shock"
	
	if Messenger.type_of_the_bullet == "normal":
		if Messenger.balas_q_tenho[0] > 0:
			play("normal")

	if Messenger.type_of_the_bullet == "big":
		if Messenger.balas_q_tenho[1] > 0:
			play("big")

	if Messenger.type_of_the_bullet == "small":
		if Messenger.balas_q_tenho[2] > 0:
			play("small")

	if Messenger.type_of_the_bullet == "bomb":
		if Messenger.balas_q_tenho[3] > 0:
			play("bomb")

	if Messenger.type_of_the_bullet == "shock":
		if Messenger.balas_q_tenho[4] > 0:
			play("shock")
