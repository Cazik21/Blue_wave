extends Label

@onready var texture: TextureRect = $"../TextureRect"

func _ready() -> void:
	Messenger.trocando_de_wave.connect(pisca_pisca)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = "   " + str(Messenger.player_lifes)

func pisca_pisca():
	texture.visible = false
	await get_tree().create_timer(0.1).timeout
	texture.visible = true
	await get_tree().create_timer(0.1).timeout
	texture.visible = false
	await get_tree().create_timer(0.1).timeout
	texture.visible = true
