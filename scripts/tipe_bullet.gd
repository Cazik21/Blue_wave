extends AnimatedSprite2D

@onready var count: Label = $"../count"



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("scoll_up"):
		Messenger.scroll_pos = (Messenger.scroll_pos + 1)%5
	
	if Input.is_action_just_pressed("scroll_down"):
		if Messenger.scroll_pos > 0:
			Messenger.scroll_pos -= 1
		else:
			Messenger.scroll_pos = 4
	
	if  Messenger.scroll_pos == 0:
		Messenger.type_of_the_bullet = "normal"
	
	if Messenger.scroll_pos == 1:
		Messenger.type_of_the_bullet = "big"
	
	if Messenger.scroll_pos == 2:
		Messenger.type_of_the_bullet = "small"
	
	if Messenger.scroll_pos == 3:
		Messenger.type_of_the_bullet = "bomb"
	
	if Messenger.scroll_pos == 4:
		Messenger.type_of_the_bullet =  "shock"
	
	play(Messenger.type_of_the_bullet)
	count.global_position.y = 41
	if Messenger.balas_q_tenho[Messenger.scroll_pos] < 10:
		count.position.x = 15
	else:
		count.position.x = 6
	count.text = str(" ", Messenger.balas_q_tenho[Messenger.scroll_pos])
