extends Node2D
@onready var _1: CollisionShape2D = $"walls/1"
@onready var _2: CollisionShape2D = $"walls/2"
@onready var _3: CollisionShape2D = $"walls/3"
@onready var _4: CollisionShape2D = $"walls/4"
@onready var collision_shape: CollisionShape2D = $Area/CollisionShape2D
@onready var spawn_timer: Timer = $"../spawn_timer"

@export var max_wave = 1
@export var posição_na_ordem = 1

var ja_enviei_pos = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_1.disabled = true
	_2.disabled = true
	_3.disabled = true
	_4.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Messenger.in_combat and Messenger.qual_combat == self.name:
		_1.disabled = false
		_2.disabled = false
		_3.disabled = false
		_4.disabled = false
	if Messenger.wave >= self.max_wave:
		Messenger.in_combat = false
		_1.disabled = true
		_2.disabled = true
		_3.disabled = true
		_4.disabled = true
		Messenger.ordem_waystones += 1
		self.queue_free()

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Messenger.qual_combat = self.name
		if not ja_enviei_pos and Messenger.ordem_waystones >= posição_na_ordem:
			Messenger.in_combat = true
			if Messenger.player_lifes < 5:
				Messenger.player_lifes = 5
			Messenger.wave = 0
			Messenger.enemies_f = 0
			Messenger.killed_enemies = 0
			spawn_timer.wait_time = 3.024
			body.global_position = collision_shape.global_position
			Messenger.player_pos_no_combat = body.global_position
			ja_enviei_pos = true
