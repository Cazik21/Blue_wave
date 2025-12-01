extends HSlider

@export var bus_name : String 
@onready var a_porcent: Label = $a_porcent

var bus_index

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	value = 100.0
	a_porcent.text = str(str(int(value)) + "%")

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	a_porcent.text = str(str(int(value)) + "%")
