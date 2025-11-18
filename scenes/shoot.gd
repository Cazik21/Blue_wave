extends RigidBody2D

var speed = 150
var shoot_dir2
var dir_for_tsh2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_dir2 = Messenger.shoot_direction
	dir_for_tsh2 = Messenger.direction_for_the_shoot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		speed = 150
		linear_velocity = shoot_dir2 * speed 

func _on_screen_notifier_screen_exited() -> void:
	queue_free()
