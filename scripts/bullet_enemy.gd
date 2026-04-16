extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape

var direction : Vector2 = Vector2.ZERO
var bullet_speed = 50
var tween
var Player = Messenger.player
var player_pos : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_pos = Player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		direction = (player_pos - global_position).normalized()

		# 2. Distância fixa de viagem
		var travel_distance = global_position.distance_to(player_pos)
		var target_pos = global_position + direction * travel_distance

		# 3. Duração baseada em VELOCIDADE
		var duration = travel_distance / bullet_speed

		# 4. Tween linear com velocidade constante
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target_pos, duration)\
		.set_trans(Tween.TRANS_LINEAR)
		tween.finished.connect(bullet_finished)

func set_direction(new_direction):
	direction = new_direction.normalized()

func bullet_finished() -> void:
	self.queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(2 - int(collision.scale > Vector2(1, 1)), global_position)
		self.queue_free()
	if body.is_in_group("Player"):
		self.queue_free()
