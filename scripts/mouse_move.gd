extends Node

var dir_of_the_mouse_vector
var mouse_speed = 120
var safe_delta
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	safe_delta = min(delta, 0.033)
	move_mouse()

func move_mouse():
	if not Input.get_vector("Mouse esq", "Mouse dir", "Mouse cima", "Mouse baixo").normalized() == Vector2.ZERO:
		dir_of_the_mouse_vector = Input.get_vector("Mouse esq", "Mouse dir", "Mouse cima", "Mouse baixo").normalized()
		var mouse_pos = get_viewport().get_mouse_position()
		mouse_pos += dir_of_the_mouse_vector * mouse_speed * safe_delta
		get_viewport().warp_mouse(mouse_pos)
