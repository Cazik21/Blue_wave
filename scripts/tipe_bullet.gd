extends AnimatedSprite2D

@onready var count: Label = $"../count"
var scroll_pos = 0


func _ready() -> void:
	Messenger.scroll_pos = 1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("scoll_up"):
		if Messenger.scroll_pos < 5:
				scroll_pos = scroll_pos%5 + 1
		else: 
			Messenger.scroll_pos = 0
	
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
	if Messenger.balas_q_tenho[Messenger.scroll_pos -1] < 10:
		count.position.x = 15
	else:
		count.position.x = 6
	var balinhas = Messenger.balas_q_tenho[Messenger.scroll_pos -1] 
	count.text = str(balinhas)
