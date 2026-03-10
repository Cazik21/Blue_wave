extends HSlider

@export var bus_name : String 
@onready var a_porcent: Label = $"../a_porcent"


var bus_index

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	if get_parent().name == "Master": #Ignore, apenas GAMBIARRAS:)
		value = Messenger.master_volume
	elif get_parent().name == "Music":
		value = Messenger.music_volume
	elif get_parent().name == "Sfx":
		value = Messenger.sounds_volume
	
	_on_value_changed(value)

func _on_value_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(_value))
	a_porcent.text = str(int(floor(_value))) + "%"
	if get_parent().name == "Master": #Aq também:))
		Messenger.master_volume = int(floor(_value))
	elif get_parent().name == "Music":
		Messenger.music_volume = int(floor(_value))
	elif get_parent().name == "Sfx":
		Messenger.sounds_volume = int(floor(_value))
